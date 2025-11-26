/**
 *
 * Description :    Alimentation de la table dim_occupation_mode
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          occupation_mode
 * Cible :          dim_occupation_mode
 */





    select
        occupation_mode_code,
        occupation_mode_libelle,
        occupation_mode_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_silver"."dbo"."occupation_mode"
