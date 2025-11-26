
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_demande_mode_logement_actuel__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_demande_mode_logement_actuel
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_ele_mode_logement_actuel      
                    int_mode_logement       
 * Cible :          int_demande_mode_logement_actuel
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_ele_mode_logement_actuel as 
(
    select 
        demande_mode_logement_actuel_demande_id,
		demande_mode_logement_actuel_cle,
		demande_mode_logement_actuel_annee,
        demande_mode_logement_actuel_ordre_affichage
    from "wh_dp_silver"."stg"."stg_gipsne_ele_mode_logement_actuel"
),

 
cte_int_mode_logement as
(
    select  
        mode_logement_cle
        , mode_logement_code
    from 
        "wh_dp_silver"."int"."int_mode_logement"
),

-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
cte_calc_stg_gipsne_ele_mode_logement_actuel as
(
    select 
          stg.demande_mode_logement_actuel_demande_id

        , ref.mode_logement_code
        , stg.demande_mode_logement_actuel_annee
        , stg.demande_mode_logement_actuel_ordre_affichage
        , 
    case
        when (demande_mode_logement_actuel_annee) = (
            select max((demande_mode_logement_actuel_annee))
            from cte_stg_gipsne_ele_mode_logement_actuel
        ) then 1
        else 0
    end

                as demande_mode_logement_actuel_annee_last_flag

    from 
        cte_stg_gipsne_ele_mode_logement_actuel stg
    left join
        cte_int_mode_logement ref
        on stg.demande_mode_logement_actuel_cle = ref.mode_logement_cle
    
),

--ajout des clés techniques
cte_hk_calc_stg_gipsne_ele_mode_logement_actuel as
(
    select
        *
        ,
    
        concat_ws(''||'', demande_mode_logement_actuel_annee, demande_mode_logement_actuel_demande_id, mode_logement_code) 
    
 
                            as demande_mode_logement_actuel_bk  
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        concat_ws(''||'', demande_mode_logement_actuel_annee, demande_mode_logement_actuel_demande_id, mode_logement_code) 
    
)  
 
 
                            as demande_mode_logement_actuel_hk  
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        cast(mode_logement_code as varchar(max))
    
)  
 
 
                            as mode_logement_hk
         
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        concat_ws(''||'', demande_mode_logement_actuel_annee, demande_mode_logement_actuel_demande_id) 
    
)  
 
 
                            as demande_et_radiation_sne_hk
    from 
        cte_calc_stg_gipsne_ele_mode_logement_actuel
),

-------------------------------------------------------------------
--*********************** ETAPE FINALE *************************
-------------------------------------------------------------------
cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_gipsne_ele_mode_logement_actuel
 )

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."int"."int_demande_mode_logement_actuel__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_demande_mode_logement_actuel__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  