/**
 *
 * Description :    Alimentation de la table intermediate int_orfi_utilisateur
 *                  Filtrage, regroupement, application de conditions, calculs
 * Fréquence :      Quotidienne
 * Mode :           Annule et remplace
 * Source:          stg_orfi_utilisateur
 * Cible :          int_orfi_utilisateur
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_stg_orfi_utilisateur as 
(
    select 
        orfi_utilisateur_id,
        orfi_utilisateur_ldap,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom_famille,
        organisme_code_union,
        organisme_groupe_libelle,
        orfi_utilisateur_email,
        orfi_utilisateur_id_keycloak,
        orfi_utilisateur_statut,
        orfi_utilisateur_creation,
        orfi_utilisateur_maj,
        orfi_utilisateur_ancien_groupe_code

        
    from 
        "wh_dp_silver"."stg"."stg_orfi_utilisateur"
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
cte_filter_stg_orfi_utilisateur as 
(
    select 
        *
        
    from 
        cte_stg_orfi_utilisateur

),



-------------------------------------------------------------------
--************* JOINTURE ET COLONNES CALCULEES ********************
-------------------------------------------------------------------
cte_calc_stg_orfi_utilisateur  as 
 (
    select
        *
    
    from cte_filter_stg_orfi_utilisateur
    --left join cte_stg_reference on ....
    --left join cte_stg_orfi_group on ....
 ),


-------------------------------------------------------------------
--********************** CLES TECHNIQUES *************************
-------------------------------------------------------------------
cte_hk_calc_stg_orfi_utilisateur as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_utilisateur_id as varchar(max))
    
)  
 
         as orfi_utilisateur_hk
    from 
        cte_calc_stg_orfi_utilisateur
),
 
-------------------------------------------------------------------
--********************** ETAPE FINALE *************************
-------------------------------------------------------------------
 
 cte_finale as 
 (
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from 
        cte_hk_calc_stg_orfi_utilisateur
 )

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale