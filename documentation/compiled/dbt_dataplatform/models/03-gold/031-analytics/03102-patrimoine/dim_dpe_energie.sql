/**
 *
 * Description :    Alimentation de la table dim_dpe_energie
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          dpe_energie
 * Cible :          dim_dpe_energie 
 */





    select
        dpe_energie_code,
        dpe_energie_libelle,
        dpe_energie_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."dpe_energie"
