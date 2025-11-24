
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_orfi_fait__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_orfi_fait
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_fait
 * Cible :          int_orfi_fait
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_fait as 
(
    select 
        orfi_fait_id,
        orfi_fait_date,
        orfi_fait_recurrent,
        orfi_fait_site,
        orfi_fait_batiment,
        orfi_fait_etage,
        orfi_fait_statut_actuel,
        orfi_fait_niveau_1_id,
        orfi_fait_niveau_2_id,
        orfi_fait_niveau_3_id,
        orfi_localisation_niveau_1_id,
        orfi_localisation_niveau_2_id,
        orfi_fait_adresse_id,
        orfi_fait_camera,
        orfi_utilisateur_ldap,
        organisme_code_union,
        orfi_statut_commentaire,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom,
        orfi_groupe_libelle,
        orfi_role_id,
        orfi_patrimoine_id, 
        orfi_secteur_id,       
        orfi_agence_id,
        orfi_utilisateur_id
      
    from 
        "wh_dp_silver"."stg"."stg_orfi_fait"
),



/*
cte_stg_reference as
(

),

cte_stg_orfi_group as 
(

)
*/

 
-------------------------------------------------------------------
--************************** FILTRAGE ****************************
-------------------------------------------------------------------

-- on souhaite recueperer que les organismes actifs
cte_filter_stg_orfi_fait as 
(
    select 
        *
        
    from 
        cte_stg_orfi_fait

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_fait  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_fait
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_fait as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(orfi_fait_id as varchar(max))
    
)  
 
         as orfi_fait_hk
    from 
        cte_calc_stg_orfi_fait
),
 
-------------------------------------------------------------------
--********************** ETAPE FINALE *************************
-------------------------------------------------------------------
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE ''Romance Standard Time'' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_orfi_fait
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."int"."int_orfi_fait__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_orfi_fait__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  