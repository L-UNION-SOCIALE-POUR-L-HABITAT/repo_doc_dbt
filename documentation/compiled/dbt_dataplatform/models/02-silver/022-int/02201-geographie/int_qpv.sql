/**
 *
 * Description :    Alimentation de la table intermediate int_qpv
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Full refresh / overwrite
 * Sources:         stg_insee_appartenance_geo_qpv24 
 * Cible :          int_qpv
 *  
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_appartenance_geo_qpv24 as
(
    select
        qpv_commune_annee    as qpv_annee     
        , qpv_code           
        , qpv_libelle       

    from
        "wh_dp_silver"."stg"."stg_insee_appartenance_geo_qpv24"

),


-- Ajout des colonnes calculées
 cte_calc_stg_insee_appartenance_geo_qpv24 as 
 (
    select
        qpv_annee                          
        , qpv_code                           
        , qpv_libelle                       
        , 
    case
        when t1.qpv_annee = (
            select max(t2.qpv_annee)
            from cte_stg_insee_appartenance_geo_qpv24 t2
            where t2.qpv_code = t1.qpv_code
        ) then 1
        else 0
    end
 as qpv_annee_last_flag

    from
        cte_stg_insee_appartenance_geo_qpv24 t1
    
     
 ),

-- Ajout des clés techniques
cte_hk_calc_stg_insee_appartenance_geo_qpv24 as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', qpv_annee, qpv_code) 
    
)  
 
 as qpv_hk
        , 
    
        concat_ws('||', qpv_annee, qpv_code) 
    
 as qpv_bk
        
    from 
        cte_calc_stg_insee_appartenance_geo_qpv24
),

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