
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "dbo"."commune__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table commune
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_commune
 * Cible :          commune 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_int_commune as
(
    select
        commune_annee,
        commune_annee_last_flag,
        commune_code,
        commune_libelle,
        commune_pays_libelle,
        commune_hk,
        commune_bk,
        departement_code,
        departement_hk,
        epci_code,
        epci_hk,
        ept_code,
        ept_hk,
        zone_123_code,
        zone_123_hk,
        zone_abc_code,
        zone_abc_hk,
        logements_prives_nombre

    from "wh_dp_silver"."int"."int_commune"
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from cte_int_commune
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."dbo"."commune__dbt_temp" AS SELECT * FROM "wh_dp_silver"."dbo"."commune__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  