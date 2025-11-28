
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_radiation_motif__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_radiation_motif
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_ref_motif_radiation             
 * Cible :          int_radiation_motif
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_ref_motif_radiation as 
(
    select 
        radiation_motif_cle,
        radiation_motif_code,
        radiation_motif_ordre_affichage,
        radiation_motif_libelle_long,
        radiation_motif_libelle_court
    from "wh_dp_silver"."stg"."stg_gipsne_ref_motif_radiation"
),

 

-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
 
cte_calc_stg_gipsne_ref_motif_radiation as
(
    select 
        *
        ,   case    when radiation_motif_code in (''RADABA'',''RADIRR'',''RADCON'') 
                    then ''Radiation''
                    else radiation_motif_libelle_court
            end as  radiation_motif_libelle_groupe
    from 
        cte_stg_gipsne_ref_motif_radiation
    
),

--ajout des clés techniques
cte_hk_calc_stg_gipsne_ref_motif_radiation as
(
    select
        *
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        cast(radiation_motif_code as varchar(max))
    
)  
 
 as radiation_motif_hk
    from 
        cte_calc_stg_gipsne_ref_motif_radiation
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
        cte_hk_calc_stg_gipsne_ref_motif_radiation
 )

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."int"."int_radiation_motif__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_radiation_motif__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  