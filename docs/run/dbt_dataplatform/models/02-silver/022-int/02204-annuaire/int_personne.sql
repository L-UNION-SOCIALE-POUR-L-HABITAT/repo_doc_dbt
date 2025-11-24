
  
    
    
    USE [wh_dp_silver];
    
    

    EXEC('create view "int"."int_personne__dbt_temp__dbt_tmp_vw" as /**
 *
 * Description :    Alimentation de la table intermediate int_organisme
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_crm_entreprise
 * Cible :          int_organisme
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_personne as 
(
    select 
        personne_id_code,
        personne_civilite_hk,
        organisme_type_code,
        organisme_type_libelle,
        organisme_siren_code,
        organisme_code_union,
        organisme_id_code,
        personne_ldap_code,
        personne_prenom_libelle,
        personne_nom_libelle,
        personne_titre_libelle,
        personne_fonction_code,
        personne_fonction_libelle,
        personne_email_libelle,
        personne_statut_code,
        personne_role_libelle


    from 
        "wh_dp_silver"."stg"."stg_crm_personne"
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
cte_filter_stg_personne as 
(
    select 
        *
        
    from 
        cte_stg_personne

    where personne_statut_code = ''Active''
),

-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_personne  as 
 (
    select
        personne_id_code,
        personne_civilite_hk,
        organisme_type_code,
        organisme_type_libelle,
        organisme_siren_code,
        organisme_code_union,
        organisme_id_code,
        personne_ldap_code,
        personne_prenom_libelle,
        personne_nom_libelle,
        personne_titre_libelle,
        personne_fonction_code,
        personne_fonction_libelle,
        personne_email_libelle,
        personne_statut_code,
        personne_role_libelle
    
    from cte_filter_stg_personne
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_personne as
(
    select 
        *
        , 
     
        HASHBYTES(''SHA2_256'', 
    
        cast(personne_id_code as varchar(max))
    
)  
 
           as personne_hk
         
    from 
        cte_calc_stg_personne
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
        cte_hk_calc_stg_personne
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale;');




    
    
            EXEC('CREATE TABLE "wh_dp_silver"."int"."int_personne__dbt_temp" AS SELECT * FROM "wh_dp_silver"."int"."int_personne__dbt_temp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-fabric-dw'');
');
        

    

  
  