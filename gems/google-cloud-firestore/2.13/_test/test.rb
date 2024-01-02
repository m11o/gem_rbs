# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "google-cloud-firestore"

client = Google::Cloud::Firestore.new
client.project_id
client.database_id
client.path

client.cols.map do |collection_reference|
  collection_reference.collection_id
end
client.cols(real_time: Time.now) do |collection_reference|
  puts collection_reference.collection_id
end

client.col('users')
col_group = client.col_group "cities"
col_group.get do |city|
  puts "#{city.document_id} has #{city[:population]} residents."
end
client.filter(:population, :>=, 1000000)

client.doc("cities/NYC").document_id
client.get_all("cities/NYC", "cities/SF", "cities/LA").map do |document_snapshot|
  document_snapshot.document_id
end
client.document_id
client.transaction do |tx|
  tx.set("cities/NYC", { name: "New York City" })
  tx.update("cities/SF", { population: 1000000 })
  tx.delete("cities/LA")
end
nyc_ref = client.doc "cities/NYC"
read_time = Time.now
client.read_only_transaction(read_time: read_time) do |tx|
  tx.get nyc_ref
end
