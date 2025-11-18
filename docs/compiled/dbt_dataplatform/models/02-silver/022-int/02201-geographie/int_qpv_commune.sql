/**
 *
 * Description :    Alimentation de la table intermediate int_qpv_commune
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Source:          stg_insee_appartenance_geo_qpv24 
 * Cible :          int_qpv_commune 
 * La table en source contient une liste de commune liée à un QPV. Dans ce traitement, la liste est découpée
 * pour obtenir une ligne par couple qpv / commune
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_appartenance_geo_qpv24 as 
(
    select 
        qpv_commune_annee,
        qpv_code ,
        qpv_libelle ,       
        commune_code_liste 
        
    from 
        "wh_dp_silver"."stg"."stg_insee_appartenance_geo_qpv24"
),

--On calcule le nombre de communes par qpv, sachant qu'un code commune est sur 5 caractères
cte_nb_communes_par_qpv  as
(
 select
        qpv_commune_annee,
        qpv_code,
        qpv_libelle,
        commune_code_liste,
        len(commune_code_liste) / 5 as nb_communes
    from cte_stg_insee_appartenance_geo_qpv24
)
,

-- Table de nombres de 1 à 15 : 10 étant le max de communes recensés pour un QPV (on prend de la marge)
cte_numbers as (
    select row_number() over (order by (select null)) as idx
    from openjson(replicate('{"x":0},', 15) + '{"x":0}')
),

-- Découpage des codes communes
cte_split_stg_insee_appartenance_geo_qpv24 as (
    select
        b.qpv_commune_annee,
        b.qpv_code,
        b.qpv_libelle,
        substring(b.commune_code_liste, ((n.idx - 1) * 5) + 1, 5) as commune_code
    from cte_nb_communes_par_qpv b
    join cte_numbers n
        on n.idx <= b.nb_communes
),

-- Ajout des colonnes calculées
cte_calc_stg_insee_appartenance_geo_qpv24  as 
 (
    select
        qpv_commune_annee,
        qpv_code,
        qpv_libelle,
        commune_code,
        
    case
        when t1.qpv_commune_annee = (
            select max(t2.qpv_commune_annee)
            from cte_split_stg_insee_appartenance_geo_qpv24 t2
            where t2.qpv_code = t1.qpv_code
        ) then 1
        else 0
    end
 as qpv_commune_annee_last_flag

    from 
        cte_split_stg_insee_appartenance_geo_qpv24 t1
    
 ),


-- Ajout des clés techniques
cte_hk_calc_stg_insee_appartenance_geo_qpv24 as
(
    select 
        *
        , 
    
        concat_ws('||', qpv_commune_annee, qpv_code, commune_code) 
    
 as qpv_commune_bk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', qpv_commune_annee, qpv_code, commune_code) 
    
)  
 
 as qpv_commune_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', qpv_commune_annee, qpv_code) 
    
)  
 
 as qpv_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', qpv_commune_annee, commune_code) 
    
)  
 
 as commune_hk
    from 
        cte_calc_stg_insee_appartenance_geo_qpv24
),
 
-- Ajout des métadonnées
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_insee_appartenance_geo_qpv24
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale