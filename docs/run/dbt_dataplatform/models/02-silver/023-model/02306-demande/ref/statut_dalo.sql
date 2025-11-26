
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."statut_dalo__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table ref_statut_dalo
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_statut_dalo
 * Cible :          ref_statut_dalo
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_statut_dalo as
(
    select
        statut_dalo_hk,
        statut_dalo_cle,
        statut_dalo_code,
        statut_dalo_ordre_affichage,
        statut_dalo_libelle_long,
        statut_dalo_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as statut_dalo_libelle_groupe
    

    from "wh_dp_silver"."int"."int_statut_dalo"
),

 
-- Sélection des colonnes 
cte_select_int_statut_dalo as
(
    select
        statut_dalo_hk,
        coalesce(statut_dalo_code, statut_dalo_cle) as statut_dalo_code,
        statut_dalo_ordre_affichage,
        statut_dalo_libelle_long,
        statut_dalo_libelle_court 
        
    
        ,null as statut_dalo_libelle_groupe
    


    from cte_int_statut_dalo
),

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
cte_finale as
(
    select
        *,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from cte_select_int_statut_dalo 
)

select 
    *
from 
    cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."statut_dalo__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."statut_dalo__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  