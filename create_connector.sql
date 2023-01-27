CREATE SOURCE CONNECTOR jdbc_connector WITH (
  'connector.class'          = 'io.confluent.connect.jdbc.JdbcSourceConnector',
  'connection.url'           = 'jdbc:postgresql://postgresql:5432/postgres',
  'connection.user'          = 'postgres',
  'connection.password'      = 'postgres',
  'topic.prefix'             = 'jdbc_',
  'table.whitelist'          = 'application_record',
  'mode'                     = 'bulk');