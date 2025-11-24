
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."reservataire_type__dbt_temp__dbt_tmp_vw" as 

/**
 *
 * Description :    Alimentation de la table ref_reservataire_type
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          int_reservataire_type
 * Cible :          ref_reservataire_type
 */













with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_int_reservataire_type as
(
    select
        reservataire_type_hk,
        reservataire_type_cle,
        reservataire_type_code,
        reservataire_type_ordre_affichage,
        reservataire_type_libelle_long,
        reservataire_type_libelle_court,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at_int
        
    
        ,null as reservataire_type_libelle_groupe
    

    from "wh_dp_silver"."int"."int_reservataire_type"
),

 
-- Sélection des colonnes 
cte_select_int_reservataire_type as
(
    select
        reservataire_type_hk,
        coalesce(reservataire_type_code, reservataire_type_cle) as reservataire_type_code,
        reservataire_type_ordre_affichage,
        reservataire_type_libelle_long,
        reservataire_type_libelle_court 
        
    
        ,null as reservataire_type_libelle_groupe
    


    from cte_int_reservataire_type
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
    from cte_select_int_reservataire_type 
)

select 
    *
from 
    cte_finale

;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."reservataire_type__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."reservataire_type__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  