from azure.cosmos import exceptions, CosmosClient, PartitionKey
import sys


databaseName = sys.argv[1]
containerName = sys.argv[2]
partitionKey = sys.argv[3]
endpoint = sys.argv[4]
key = sys.argv[5]

# Initialize the Cosmos client
client = CosmosClient(endpoint, key)

database = client.get_database_client(databaseName)

containerClient = database.get_container_client(containerName)

query = "SELECT * FROM c"

items = list(containerClient.query_items(
    query=query,
    enable_cross_partition_query=True
))

itemsCount = len(items)

print(f"Items to delete from {containerName}: {itemsCount}")
delete = input("Do you want to continue? (Y/N): ")

if delete.upper() == "Y":    
    for doc in items:    
        containerClient.delete_item(doc, partition_key=doc[partitionKey])
    print("Deleted all items")
else:
    print("Skipped deleting items")