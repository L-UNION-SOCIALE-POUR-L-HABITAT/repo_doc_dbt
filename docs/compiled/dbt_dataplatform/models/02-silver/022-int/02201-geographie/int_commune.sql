/**
 *
 * Description :    Alimentation de la table intermediate int_commune
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Sources:         stg_insee_appartenance_geo_commune
 * Cible :          int_ept 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_insee_appartenance_geo_commune as 
(
    select
         commune_annee,
         commune_code,
         commune_libelle,
         departement_code,
         epci_code,
         ept_code

    from 
         "wh_dp_silver"."stg"."stg_insee_appartenance_geo_commune"
),

cte_transform_stg_insee_appartenance_geo_commune as
(
    select
         commune_annee,
         commune_code,
         commune_libelle,
         departement_code,
         epci_code,
         ept_code
    from 
         cte_stg_insee_appartenance_geo_commune
),

cte_stg_ministere_zone_123 as
(
    select
        commune_code
        ,zone_123_code
    
    from 
         "wh_dp_silver"."stg"."stg_ministere_zone_123"
),

cte_stg_ministere_zone_abc as
(
    select
        commune_code
        ,zone_abc_code
    from 
         "wh_dp_silver"."stg"."stg_ministere_zone_abc"
),

cte_int_commune_residence_principale_histo as
(
    select
        commune_annee,
        commune_code,
        logements_prives_nombre 
    
    from 
         "wh_dp_silver"."int"."int_commune_residence_principale_histo"
),

-- Ajout des colonnes calculées
 cte_calc_stg_insee_appartenance_geo_commune as 
 (
    select
        t1.*
        , isnull(zone_123_code,'N/A') as zone_123_code
        , isnull(zone_abc_code,'N/A') as zone_abc_code
        , logements_prives_nombre
        -- ajouter pour la partie dataviz: permet de localiser les communes sur une carte
        , concat (commune_libelle,', France') as commune_pays_libelle
        , 
    case
        when t1.commune_annee = (
            select max(t2.commune_annee)
            from cte_transform_stg_insee_appartenance_geo_commune t2
            where t2.commune_code = t1.commune_code
        ) then 1
        else 0
    end
 as commune_annee_last_flag

    from
        --important ici de mettre l'alias t1
        cte_transform_stg_insee_appartenance_geo_commune t1   

    left join
        cte_stg_ministere_zone_123 zone_123
    on
        zone_123.commune_code = t1.commune_code

    left join
        cte_stg_ministere_zone_abc zone_abc
    on
        zone_abc.commune_code = t1.commune_code

     left join
        cte_int_commune_residence_principale_histo rp
    on
        rp.commune_code = t1.commune_code and
        rp.commune_annee = t1.commune_annee
 ),

-- Ajout des clés techniques
cte_hk_calc_insee_appartenance_geo_commune as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', commune_annee, commune_code) 
    
)  
 
       as commune_hk
        , 
    
        concat_ws('||', commune_annee, commune_code) 
    
   as commune_bk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', commune_annee, departement_code) 
    
)  
 
   as departement_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', commune_annee, epci_code) 
    
)  
 
          as epci_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', commune_annee, ept_code) 
    
)  
 
           as ept_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(zone_123_code as varchar(max))
    
)  
 
                       as zone_123_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(zone_abc_code as varchar(max))
    
)  
 
                       as zone_abc_hk
    from 
        cte_calc_stg_insee_appartenance_geo_commune
),

 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_insee_appartenance_geo_commune
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale