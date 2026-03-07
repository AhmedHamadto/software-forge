# Designing Data-Intensive Applications (Martin Kleppmann) — Teaching Content

## Data Modeling

### Deep (first exposure)

Every application stores data, and the shape you give that data determines what questions you can ask efficiently and how your system evolves over time. Kleppmann devotes Chapters 2 and 3 to this foundational choice because getting it wrong creates pain that compounds with every feature you add. The core tension is between relational models (tables with rows and foreign keys) and document models (nested JSON-like structures), each of which makes certain operations natural and others awkward.

Relational models normalize data: you store each fact exactly once and use joins to assemble it. A customer's address lives in an `addresses` table, referenced by a foreign key from `orders`. Change the address once, and every order reflects the update. This is powerful for data integrity and ad-hoc queries, but joins have a cost — especially across large tables or distributed systems. Schema-on-write (the relational approach) means you define the shape of your data upfront with a schema, and every write must conform. This catches errors early but makes schema evolution slower (ALTER TABLE on a billion-row table is no joke).

Document models denormalize: you embed the customer's address directly inside each order document. No joins needed — reading an order gives you everything in one fetch. This matches how applications often use data (load the whole order, render it), and schema-on-read means the database accepts whatever shape you write. Your application code decides how to interpret it at read time. But if the customer moves, you have to update the address in every order document that embedded it — or accept that old orders keep the old address (which might actually be correct for shipping records).

The practical answer is almost never purely one or the other. A social application might store user profiles as documents (varied structure, read as a unit) but track friendships in a relational table (many-to-many relationships are painful in documents). Kleppmann's guidance: if your data has a tree-like structure and you typically load the whole tree, documents work well. If your data has many-to-many relationships or you need flexible querying across relationships, relational models are stronger. The worst outcome is choosing based on what is trendy rather than what your access patterns demand.

### Refresher (subsequent exposure)

Relational models normalize data and use joins, giving you flexible queries and single-source-of-truth updates at the cost of read complexity. Document models denormalize and embed, giving fast reads of whole entities at the cost of update complexity. Choose based on your access patterns — how you read and write the data in practice — not based on technology preference.

### Socratic Questions

- Your API returns a user profile with their 10 most recent posts and a list of followers. You are choosing between PostgreSQL and MongoDB. What access patterns would push you toward each, and what trade-offs would you accept?
- You have a `products` table with a `metadata` JSONB column that teams keep adding fields to without migrations. What are the benefits and risks of this schema-on-read approach compared to adding explicit columns with a migration?
- Your e-commerce system stores the product name and price inside each order line item (denormalized). A product manager asks why the orders page shows the old price after they updated a product. Is this a bug or a feature? How does your data modeling decision affect the answer?

---

## Replication

### Deep (first exposure)

Once your application has users in multiple regions, or once your database is too important to run on a single machine, you need replication — keeping copies of the same data on multiple nodes. Kleppmann covers this in Chapter 5, and the core insight is that replication is not just about redundancy. It determines your system's consistency guarantees, latency characteristics, and failure behavior. Every replication strategy is a trade-off, and pretending otherwise leads to subtle, data-corrupting bugs.

Leader-follower (also called primary-replica) replication is the most common setup. One node is the leader; all writes go to it. The leader streams changes to follower nodes, which serve read queries. This is simple and gives you read scaling, but introduces replication lag — a user writes data to the leader, then reads from a follower that has not received the update yet, and sees stale data. Read-after-write consistency is the property that says "if I just wrote something, I should see my own write." Achieving this in a leader-follower setup requires routing the user's reads to the leader for recently written data, or tracking replication positions.

Multi-leader replication allows writes to multiple nodes (useful for multi-datacenter deployments), but now you face write conflicts — two leaders accept conflicting updates to the same record. Conflict resolution strategies (last-write-wins, merge, custom logic) are all lossy or complex. Leaderless replication (as in Dynamo-style systems) takes this further: any node accepts reads and writes, using quorum-based consistency (read from R nodes, write to W nodes, where R + W > N ensures overlap). This maximizes availability but makes consistency reasoning harder.

The practical lesson is that "eventual consistency" is not a single thing — it is a spectrum. Will your followers catch up in milliseconds or minutes? What happens during a network partition? Kleppmann warns that the default settings of most databases do not give you the guarantees you probably assume you have. If your application lets a user update their profile and then immediately displays it, you need read-after-write consistency, and you must explicitly design for it. If your system processes financial transactions, you likely need stronger guarantees than what a leaderless system provides out of the box.

### Refresher (subsequent exposure)

Replication keeps data copies on multiple nodes. Leader-follower is simplest but introduces replication lag. Multi-leader and leaderless offer more availability but create conflict resolution challenges. Always identify what consistency guarantee your application actually needs — especially read-after-write — and verify that your replication setup provides it rather than assuming it does.

### Socratic Questions

- Your application uses a PostgreSQL read replica for the dashboard queries. A user updates their display name, refreshes the page, and sees the old name. What is happening, and what are two different ways you could fix it?
- You are considering a multi-leader database setup for a collaborative document editor with users in the US and Europe. What kinds of conflicts could arise when two users edit the same document simultaneously, and how would you resolve them?
- Your team is debating between a single-leader Postgres setup and a leaderless DynamoDB setup for an order processing system. What questions about your workload and consistency requirements would you need to answer before choosing?
