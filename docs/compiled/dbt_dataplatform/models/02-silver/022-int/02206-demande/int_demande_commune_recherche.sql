/**
 *
 * Description :    Alimentation de la table intermediate int_demande_commune_recherche
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_ele_classement_commune     
                    stg_gipsne_ref_geographie       
 * Cible :          int_demande_commune_recherche
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_ele_classement_commune as 
(
    select 
        demande_commune_recherche_demande_id,
		demande_commune_recherche_commune_cle,
		demande_commune_recherche_annee,
        demande_commune_recherche_ordre_priorite
    from "wh_dp_silver"."stg"."stg_gipsne_ele_classement_commune"
),

 
cte_stg_gipsne_ref_geographie as
(
    select  
        geographie_sne_commune_cle
        , geographie_sne_commune_code
        , geographie_sne_commune_libelle
    from 
        "wh_dp_silver"."stg"."stg_gipsne_ref_geographie"
),

-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
cte_calc_stg_gipsne_ele_classement_commune as
(
    select 
        stg.demande_commune_recherche_demande_id    as demande_id 
        , ref.geographie_sne_commune_code           as commune_code  
        , stg.demande_commune_recherche_annee
        , stg.demande_commune_recherche_ordre_priorite  
        , 
    case
        when (demande_commune_recherche_annee) = (
            select max((demande_commune_recherche_annee))
            from cte_stg_gipsne_ele_classement_commune
        ) then 1
        else 0
    end

                as demande_commune_recherche_annee_last_flag

    from 
        cte_stg_gipsne_ele_classement_commune stg
    left join
        cte_stg_gipsne_ref_geographie ref
        on stg.demande_commune_recherche_commune_cle = ref.geographie_sne_commune_cle
    
),

--ajout des clés techniques et fonctionnels
cte_hk_calc_stg_gipsne_ele_classement_commune as
(
    select
        *
        ,
    
        concat_ws('||', demande_commune_recherche_annee, demande_id, commune_code) 
    
 
                            as demande_commune_recherche_bk  
        ,
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', demande_commune_recherche_annee, demande_id, commune_code) 
    
)  
 
 
                            as demande_commune_recherche_hk  
        ,
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', demande_commune_recherche_annee, commune_code) 
    
)  
 
 
                            as commune_hk
         
        ,
     
        HASHBYTES('SHA2_256', 
    
        concat_ws('||', demande_commune_recherche_annee, demande_id) 
    
)  
 
 
                            as demande_et_radiation_sne_hk
    from 
        cte_calc_stg_gipsne_ele_classement_commune
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_gipsne_ele_classement_commune
 )

 
select 
    *
from 
    cte_finale