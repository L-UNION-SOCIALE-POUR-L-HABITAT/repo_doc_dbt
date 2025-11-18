/**
 *
 * Description :    Alimentation de la table staging stg_insee_appartenance_geo_qpv24
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_appartenance_geo_qpv24
 * Cible :          stg_insee_appartenance_geo_qpv24 
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_insee_appartenance_geo_qpv24 as 
 (
    select 
        [_meta_year]        as qpv_commune_annee ,
        [QP]                as qpv_code ,
        [LIB_QP]            as qpv_libelle ,       
        [LIST_COM]          as commune_code_liste ,
        [LIST_LIB_COM]      as commune_libelle_liste ,
        [LIST_COMARR]       as arrondissement_code_liste ,
        [LIST_LIB_COMARR]   as arrondissement_libelle_liste
        -- [ZONE_EPCI_1],
        -- [ZONE_EPCI_2],
        -- [LIST_ZONE_EPCI],
        -- [LIST_LIB_ZONE_EPCI],
        -- [REG],
        -- [DEP],
        -- [UU2020],
        -- [FUSION_COM_2324],
        -- [LISTE_COM_MODIF_2324],
        -- [FUSION_EPCI_2324],
        -- [LISTE_EPCI_MODIF_2324],
      
    from   "wh_dp_bronze"."raw"."raw_insee_appartenance_geo_qpv24"
 ),


-------------------------------------------------------------------
--************* NETTOYAGE ET TYPAGE DES COLONNES ******************
-------------------------------------------------------------------

cte_clean_and_type_raw_insee_appartenance_geo_qpv24 as 
 (
    select
        
    case
        -- Valeurs nulles ou codes à ignorer
        when qpv_commune_annee is null 
          or qpv_commune_annee in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(qpv_commune_annee as integer) is not null 
        then cast(qpv_commune_annee as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(qpv_commune_annee as float) is not null 
        then cast(cast(qpv_commune_annee as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
 as qpv_commune_annee,
        qpv_code ,
        qpv_libelle ,       
        commune_code_liste ,
        commune_libelle_liste ,
        arrondissement_code_liste ,
        arrondissement_libelle_liste
      
    from   cte_rename_insee_appartenance_geo_qpv24
 ),

 cte_finale as
(
    select 
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_clean_and_type_raw_insee_appartenance_geo_qpv24
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale