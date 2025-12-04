/**
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
        orfi_fait_id_code,
        orfi_fait_date,
        orfi_fait_recurrent_flag,
        orfi_fait_site,
        orfi_fait_batiment,
        orfi_fait_etage,
        orfi_fait_statut_actuel,
        orfi_fait_niveau_1_id_code,
        orfi_fait_niveau_2_id_code,
        orfi_fait_niveau_3_id_code,
        orfi_localisation_niveau_1_id_code,
        orfi_localisation_niveau_2_id_code,
        orfi_fait_adresse_id_code,
        orfi_fait_camera_flag,
        personne_ldap_code,
        organisme_code_union,
        orfi_statut_commentaire,
        orfi_utilisateur_prenom,
        orfi_utilisateur_nom,
        orfi_groupe_libelle,
        orfi_role_id_code,
        orfi_patrimoine_id_code, 
        orfi_secteur_id_code,       
        orfi_agence_id_code,
        orfi_utilisateur_id_code
      
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

    where   
    orfi_fait_date >= cast('2021-01-01' as date)

        and orfi_fait_statut_actuel <> 'REFUSED'

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
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_fait_id_code as varchar(max))
    
)  
 
                       as orfi_fait_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_fait_niveau_1_id_code as varchar(max))
    
)  
 
              as orfi_fait_niveau_1_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_fait_niveau_2_id_code as varchar(max))
    
)  
 
              as orfi_fait_niveau_2_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_fait_niveau_3_id_code as varchar(max))
    
)  
 
              as orfi_fait_niveau_3_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_localisation_niveau_1_id_code as varchar(max))
    
)  
 
      as orfi_localisation_niveau_1_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_localisation_niveau_2_id_code as varchar(max))
    
)  
 
      as orfi_localisation_niveau_2_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_fait_adresse_id_code as varchar(max))
    
)  
 
               as orfi_fait_adresse_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_role_id_code as varchar(max))
    
)  
 
                       as orfi_role_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_patrimoine_id_code as varchar(max))
    
)  
 
                 as orfi_patrimoine_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_secteur_id_code as varchar(max))
    
)  
 
                    as orfi_secteur_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_agence_id_code as varchar(max))
    
)  
 
                     as orfi_agence_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(orfi_utilisateur_id_code as varchar(max))
    
)  
 
                as orfi_utilisateur_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(personne_ldap_code as varchar(max))
    
)  
 
                      as personne_ldap_code_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(organisme_code_union as varchar(max))
    
)  
 
                    as organisme_code_union_hk

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
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
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
    cte_finale