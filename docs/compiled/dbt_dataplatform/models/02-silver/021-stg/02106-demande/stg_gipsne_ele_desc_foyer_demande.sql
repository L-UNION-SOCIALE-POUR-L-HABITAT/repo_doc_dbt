/**
 *
 * Description :    Alimentation de la table staging stg_gipsne_ele_desc_foyer_demande
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          raw_gipsne_ele_desc_foyer_demande
 * Cible :          stg_gipsne_ele_desc_foyer_demande
 *test
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_gipsne_ele_desc_foyer_demande as 
 (
    select 
        [DEMANDE]                       as demandeur_foyer_demande_id,
        [TYPE_PERSONNE]                 as demandeur_type_code,
        [DATENAISSANCE]                 as demandeur_foyer_naissance_date,
        [AGE]                           as demandeur_foyer_age,
        [ORDRE]                         as demandeur_foyer_ordre_affichage,
        [ELEMENTLIENDEMANDEUR_ID]       as demandeur_lien_cle,
        [_meta_year]                    as demandeur_foyer_annee
        -- [ELEMENTCIVILITE_ID],
        -- [SITUATIONPROFESSIONNELLE_ID],
        -- [ELEMENTNATIONALITE_ID],
        -- [ELEMENTSITUATIONFAMILIALE_ID],
        -- [REVENU_MENSUEL],
        -- [ANNEEMOINS1],
        -- [REVENU_FISCAL_ANNEEMOINS1],
        -- [ANNEEMOINS2],
        -- [REVENU_FISCAL_ANNEEMOINS2],
        -- [QUOTIENT_UC],
        -- [MULTI_EMPLOYEUR],
        -- [NIR_ID_DEMANDEUR],
        -- [NIR_ID_COTITULAIRE],
        -- [NB_CDD_INTERIM],
        -- [NB_CHOMAGE_LONG],
        -- [DATE_SORTIE_CHOMAGELONG],
        -- [NB_TRAVAILLEUR_ESSENTIEL],
      
    

    from   "wh_dp_bronze"."raw"."raw_gipsne_ele_desc_foyer_demande"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_gipsne_ele_desc_foyer_demande as 
 (
    select
        demandeur_foyer_demande_id,
        demandeur_type_code,
        
    case
        when demandeur_foyer_naissance_date is null or trim(demandeur_foyer_naissance_date) = '' then CAST(NULL AS DATE)
        when upper(trim(demandeur_foyer_naissance_date)) in ('NA', 'NA/NA') then CAST(NULL AS DATE)

        
       -- Exemple en entrée : '24-06-2020 00:00:00'
        when len(trim(demandeur_foyer_naissance_date)) < 10 then CAST(NULL AS DATE)
        else TRY_CAST(
            CONCAT(
                SUBSTRING(trim(REPLACE(demandeur_foyer_naissance_date, '/', '-')), 7, 4), '-',  -- AAAA
                SUBSTRING(trim(REPLACE(demandeur_foyer_naissance_date, '/', '-')), 4, 2), '-',  -- MM
                SUBSTRING(trim(REPLACE(demandeur_foyer_naissance_date, '/', '-')), 1, 2)        -- JJ
            ) AS DATE
        )
    
    end
 
                                                                    as demandeur_foyer_naissance_date,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_foyer_age is null 
          or demandeur_foyer_age in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_foyer_age as integer) is not null 
        then cast(demandeur_foyer_age as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demandeur_foyer_age as float) is not null 
        then cast(cast(demandeur_foyer_age as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
        as demandeur_foyer_age,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_foyer_ordre_affichage is null 
          or demandeur_foyer_ordre_affichage in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_foyer_ordre_affichage as integer) is not null 
        then cast(demandeur_foyer_ordre_affichage as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demandeur_foyer_ordre_affichage as float) is not null 
        then cast(cast(demandeur_foyer_ordre_affichage as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
  as demandeur_foyer_ordre_affichage, 
        demandeur_lien_cle,
         
    case
        -- Valeurs nulles ou codes à ignorer
        when demandeur_foyer_annee is null 
          or demandeur_foyer_annee in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(demandeur_foyer_annee as integer) is not null 
        then cast(demandeur_foyer_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(demandeur_foyer_annee as float) is not null 
        then cast(cast(demandeur_foyer_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
     as demandeur_foyer_annee 
       
    from  cte_rename_raw_gipsne_ele_desc_foyer_demande
 ),
 
-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------

cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_gipsne_ele_desc_foyer_demande
)

 
select 
    *
from 
    cte_finale