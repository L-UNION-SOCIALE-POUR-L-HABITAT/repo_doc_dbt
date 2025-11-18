/**
 *
 * Description :    Alimentation de la table staging stg_insee_passage_commune
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_passage_commune
 * Cible :          stg_passage_commune_histo
 */




 with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_insee_passage_commune as 
 (
    select 
        [_meta_year]                as passage_commune_annee,
        [CODGEO_INI]                as commune_initiale_code,
        [CODGEO]                    as commune_finale_code,   
        [LIBGEO]                    as commune_finale_libelle
 
    from   "wh_dp_bronze"."raw"."raw_insee_passage_commune"
 ),

-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------
cte_clean_and_type_raw_insee_passage_commune as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when passage_commune_annee is null 
          or passage_commune_annee in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(passage_commune_annee as integer) is not null 
        then cast(passage_commune_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(passage_commune_annee as float) is not null 
        then cast(cast(passage_commune_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as passage_commune_annee,
        commune_initiale_code,
        commune_finale_code,
        commune_finale_libelle

    from  cte_rename_raw_insee_passage_commune
 ),
 
cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_insee_passage_commune
)

     

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale