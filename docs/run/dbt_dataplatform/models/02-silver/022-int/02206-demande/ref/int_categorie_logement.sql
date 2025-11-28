
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_categorie_logement__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_categorie_logement
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          stg_gipsne_ref_categ_logement
                    stg_gipsne_ref_categ_logement_rech
 * Cible :          int_categorie_logement
 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
cte_stg_gipsne_ref_categ_logement_rech as 
(
    select 
        categorie_logement_cle,
        categorie_logement_code,
        categorie_logement_ordre_affichage,
        categorie_logement_libelle_long,
        categorie_logement_libelle_court
    from "wh_dp_silver"."stg"."stg_gipsne_ref_categ_logement_rech"
),

cte_stg_gipsne_ref_categ_logement as 
(
    select 
        categorie_logement_cle,
        categorie_logement_code,
        categorie_logement_ordre_affichage,
        categorie_logement_libelle_long,
        categorie_logement_libelle_court
    from "wh_dp_silver"."stg"."stg_gipsne_ref_categ_logement"
),

-------------------------------------------------------------------
--*********************** TRANSFORMATIONS *************************
-------------------------------------------------------------------
--union des 2 tables
cte_union_stg_gipsne_ref_categ_logement as
(
    select *
    from cte_stg_gipsne_ref_categ_logement_rech
    union
    select *
    from cte_stg_gipsne_ref_categ_logement
),

--ajout des clés techniques
cte_hk_calc_stg_gipsne_ref_categ_logement as
(
    select
        *
        ,
     
        HASHBYTES(''SHA2_256'', 
    
        cast(categorie_logement_code as varchar(max))
    
)  
 
 as categorie_logement_hk
    from 
        cte_union_stg_gipsne_ref_categ_logement
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
        cte_hk_calc_stg_gipsne_ref_categ_logement
 )

 
select 
    *
from 
    cte_finale;');




    
    EXEC('CREATE TABLE "wh_dp_silver"."int"."int_categorie_logement__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_categorie_logement__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
    

  
  