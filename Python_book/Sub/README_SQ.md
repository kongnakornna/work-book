PS C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend> (Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned) ; (& c:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend\.venv\Scripts\Activate.ps1)
(fastapi-clean-architecture-ddd-template) PS C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend> python -c "               
>> from app.core.security import hash_password                 
>> for pw in ['Admin@1234','User@1234','Guest@1234']:
>>     print(pw, '->', hash_password(pw))
>> "
Admin@1234 -> $argon2id$v=19$m=65536,t=3,p=4$ZST87KmwBqYXdHKECX3XlA$AGMOjIV2WXGiLWlGhKG3h6e1ehlIua+aCEiunLF+h50
User@1234 -> $argon2id$v=19$m=65536,t=3,p=4$CuizeI2RgP728clFm9sPug$qm/OHQvgtuSpJI9AzMaMlQSW71xpFgeNmkfzdK4J3BE
Guest@1234 -> $argon2id$v=19$m=65536,t=3,p=4$z4xy2xWgjNYsiRhK1H02Ew$TVa5x+GB1SKzsdmCYrxwipD1p8vHaWAmvs01MT6+Oyk
(fastapi-clean-architecture-ddd-template) PS C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend> 


 python -c "from app.core.security import hash_password; print(hash_password('Admin@1234'))"


CREATE TABLE erp_keys (
        name VARCHAR(255) NOT NULL, 
        description TEXT, 
        prefix VARCHAR(32) NOT NULL, 
        last_four VARCHAR(4) NOT NULL, 
        hashed_key VARCHAR(255) NOT NULL, 
        expires_at TIMESTAMP WITH TIME ZONE, 
        last_used_at TIMESTAMP WITH TIME ZONE, 
        created_by BIGINT NOT NULL, 
        updated_by BIGINT NOT NULL, 
        id UUID DEFAULT gen_random_uuid() NOT NULL, 
        is_active BOOLEAN DEFAULT 'true' NOT NULL, 
        created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL, 
        PRIMARY KEY (id), 
        FOREIGN KEY(created_by) REFERENCES erp_users (id) ON DELETE RESTRICT, 
        FOREIGN KEY(updated_by) REFERENCES erp_users (id) ON DELETE RESTRICT, 
        CONSTRAINT uq_keys_hashed_key UNIQUE (hashed_key)
)


# Clear alembic_version + stamp head + restart
uv run python -c @'
import asyncio
from sqlalchemy import text
from app.core.database import pg_async_engine
async def main():
    async with pg_async_engine.begin() as conn:
        await conn.execute(text("DELETE FROM alembic_version"))
        print("cleared")
asyncio.run(main())
'@

uv run alembic stamp head

make dev


(fastapi-backend) PS C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend> uv run python scripts\check_schema.py
2026-09-29 11:22:49,249 INFO sqlalchemy.engine.Engine select pg_catalog.version()
2026-09-29 11:22:49,250 INFO sqlalchemy.engine.Engine [raw sql] {}
2026-09-29 11:22:49,251 INFO sqlalchemy.engine.Engine select current_schema()
2026-09-29 11:22:49,252 INFO sqlalchemy.engine.Engine [raw sql] {}
2026-09-29 11:22:49,253 INFO sqlalchemy.engine.Engine show standard_conforming_strings
2026-09-29 11:22:49,253 INFO sqlalchemy.engine.Engine [raw sql] {}
2026-09-29 11:22:49,256 INFO sqlalchemy.engine.Engine BEGIN (implicit)
2026-09-29 11:22:49,256 INFO sqlalchemy.engine.Engine SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name
2026-09-29 11:22:49,256 INFO sqlalchemy.engine.Engine [generated in 0.00025s] {}
Tables: ['activity_log', 'alembic_version', 'auth_access_tokens', 'auth_authentications', 'auth_refresh_tokens', 'bigo_cache_stats', 'bigo_kafka_consumers', 'bigo_kafka_queues', 'bigo_kafka_topics', 'bigo_memory_leaks', 'bigo_memory_snapshots', 'bigo_metrics', 'bigo_profiles', 'bigo_ws_sessions', 'command_log', 'device_alert', 'device_config', 'device_status', 'erp_access_tokens', 'erp_authentications', 'erp_notifications', 'erp_refresh_tokens', 'erp_users', 'erp_users_copy1', 'eval_datasets', 'eval_metrics', 'eval_reports', 'eval_results', 'eval_runs', 'eval_test_cases', 'fs_areas', 'fs_device_area', 'fs_groups', 'fs_schedule', 'fs_schedule_device', 'fs_schedule_history', 'fs_schedule_settings', 'fs_zones', 'iot_data', 'lc_agents', 'lc_chains', 'lc_memories', 'lc_runs', 'lc_traces', 'llm_conversations', 'llm_messages', 'llm_models', 'llm_providers', 'llm_usage_logs', 'pdpa_consent_logs', 'pdpa_cookie_consents', 'pdpa_dsar_requests', 'pdpa_idempotency_keys', 'pdpa_privacy_policies', 'rag_chunks', 'rag_citations', 'rag_documents', 'rag_pipelines', 'rag_retrieval_logs', 'rag_runs', 'sd_air_control', 'sd_air_control_device_map', 'sd_air_control_log', 'sd_air_mod', 'sd_air_mod_device_map', 'sd_air_period', 'sd_air_period_device_map', 'sd_air_setting_warning', 'sd_air_setting_warning_device_map', 'sd_air_warning', 'sd_air_warning_device_map', 'sd_alarm_process_log', 'sd_alarm_process_log_email', 'sd_alarm_process_log_temp', 'sd_api_key', 'sd_audit_log', 'sd_channel_template', 'sd_device_category', 'sd_device_group', 'sd_device_member', 'sd_device_notification_config', 'sd_device_schedule', 'sd_device_status_history', 'sd_group_notification_config', 'sd_iot_alarm_device', 'sd_iot_alarm_device_event', 'sd_iot_device', 'sd_iot_device_alarm_action', 'sd_iot_device_type', 'sd_iot_location', 'sd_iot_mqtt', 'sd_iot_schedule', 'sd_iot_schedule_device', 'sd_mqtt_host', 'sd_notification_channel', 'sd_notification_condition', 'sd_notification_log', 'sd_notification_type', 'sd_report_data', 'sd_schedule_process_log', 'sd_sensor_data', 'sd_system_setting', 'so_outputs', 'so_repairs', 'so_requests', 'so_schemas', 'so_validations', 'tool_definitions', 'tool_invocations', 'tool_permissions', 'tool_registrations']
2026-09-29 11:22:49,261 INFO sqlalchemy.engine.Engine SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'erp_users' AND column_name = 'id'
2026-09-29 11:22:49,261 INFO sqlalchemy.engine.Engine [generated in 0.00026s] {}
erp_users.id: [('id', 'uuid')]
2026-09-29 11:22:49,269 INFO sqlalchemy.engine.Engine SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_name IN ('erp_users','erp_keys','erp_authentications','erp_refresh_tokens','erp_access_tokens') ANDcolumn_name IN ('id','user_id','authentication_id','refresh_id','created_by','updated_by') ORDER BY table_name, column_name
2026-09-29 11:22:49,269 INFO sqlalchemy.engine.Engine [generated in 0.00026s] {}
FK columns:
   ('erp_access_tokens', 'id', 'uuid')
   ('erp_access_tokens', 'refresh_id', 'uuid')
   ('erp_authentications', 'id', 'uuid')
   ('erp_authentications', 'user_id', 'uuid')
   ('erp_refresh_tokens', 'authentication_id', 'uuid')
   ('erp_refresh_tokens', 'id', 'uuid')
   ('erp_users', 'id', 'uuid')
2026-09-29 11:22:49,273 INFO sqlalchemy.engine.Engine ROLLBACK
(fastapi-backend) PS C:\github\fastapi-clean-architecture-ddd-erp-iot\fastapi-backend> 
