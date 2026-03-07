# Domain-Driven Design (Eric Evans) — Teaching Content

## Bounded Contexts

### Deep (first exposure)

When teams build software, there is a natural temptation to create one unified model that represents every concept in the business. An "Order" in the sales system, the warehouse system, and the billing system all seem like the same thing — so why not share one Order class everywhere? The answer, as Evans explains in Chapter 14, is that each of these systems uses the word "Order" to mean something subtly different. In sales, an Order is a promise with line items and discounts. In the warehouse, an Order is a pick list with bin locations and weights. In billing, an Order is an invoice with tax calculations and payment terms. Forcing these into a single model creates a tangled mess where every change in one area risks breaking another.

A Bounded Context is an explicit boundary within which a particular domain model is defined and applicable. Inside a Bounded Context, every term has one precise meaning, and the model is internally consistent. The "Order" in the warehouse context has warehouse-specific fields and behaviors; it does not carry the baggage of sales discounts or tax rules. Each context owns its own code, its own database schema (or at minimum its own tables), and its own team understanding of the domain language.

Consider an e-commerce platform. You might identify separate Bounded Contexts for Catalog (products, categories, pricing), Ordering (cart, checkout, order lifecycle), Fulfillment (picking, packing, shipping), and Payments (charges, refunds, ledger entries). The Catalog context knows a Product as a thing with images, descriptions, and a price. The Fulfillment context knows a Shipment Item as a thing with a SKU, weight, and warehouse location. They communicate through well-defined integration points — not by sharing a Product class. A Context Map documents these relationships: which contexts exist, how they relate (upstream/downstream, shared kernel, anti-corruption layer), and where translation happens.

Without Bounded Contexts, you get the "Big Ball of Mud" — a single codebase where changing how prices are displayed breaks the shipping weight calculation because they share a data structure. Teams step on each other, deployments are all-or-nothing, and the code becomes increasingly difficult to reason about. Evans is emphatic: the biggest danger in large systems is not getting a single model wrong, but failing to recognize that you need multiple models with explicit boundaries between them.

### Refresher (subsequent exposure)

A Bounded Context is an explicit boundary within which a domain model has one consistent meaning. Different parts of the system model the same real-world concept differently, and that is correct — not a problem to fix. When you encounter a concept that means different things to different parts of your system, that is a signal you have found a context boundary.

### Socratic Questions

- Your system has a `User` object used by authentication, billing, and social features. The billing team wants to add `payment_method` and `tax_id` fields, while the social team wants `avatar_url` and `bio`. What problems do you foresee if they share the same `User` model, and how would Bounded Contexts help?
- You are building a context map and discover that your Orders service and your Inventory service both need to know when a product's price changes. Should they share a database table for products, or communicate differently? What are the trade-offs?
- A teammate proposes creating a shared library with all the domain models so every microservice uses the same classes. What is the risk of this approach from a Bounded Context perspective?

---

## Aggregates

### Deep (first exposure)

Inside a Bounded Context, you have entities and value objects that work together to enforce business rules. But which objects should be loaded together? Which objects must be consistent with each other at all times? And how do you prevent two concurrent operations from leaving your data in a contradictory state? These are the questions that Aggregates answer. Evans introduces them in Chapter 6 as a pattern for defining consistency boundaries within a domain model.

An Aggregate is a cluster of domain objects that are treated as a single unit for the purpose of data changes. Every Aggregate has a root entity — the Aggregate Root — which is the only object that external code is allowed to reference directly. All access to objects inside the Aggregate goes through the root, and the root is responsible for enforcing the Aggregate's invariants (business rules that must always be true). When you save an Aggregate, you save the entire cluster in a single transaction. When you load it, you load the whole thing.

Consider an e-commerce Order. The Order (Aggregate Root) contains OrderLineItems. A business invariant says the order total must equal the sum of all line item prices. If you allowed external code to modify an OrderLineItem directly — say, changing its price — without going through the Order, you could end up with an order total that does not match its line items. By making Order the Aggregate Root and requiring all modifications to go through it, the Order can recalculate its total every time a line item changes, keeping the invariant intact. Crucially, the transaction boundary aligns with the Aggregate boundary: you save the Order and all its line items in one atomic operation.

The practical consequence of Aggregates is that they constrain your transaction boundaries. You should not have a single transaction that spans multiple Aggregates, because that creates contention and scaling bottlenecks. If placing an Order also needs to reserve Inventory, those are two separate Aggregates — the Order is saved in one transaction, and an event triggers the Inventory reservation in another. This means you accept eventual consistency between Aggregates while maintaining strong consistency within each one. Getting Aggregate boundaries wrong — making them too large or too small — is one of the most common and costly design mistakes in domain-driven systems.

### Refresher (subsequent exposure)

An Aggregate is a consistency boundary: a cluster of objects with a root entity that enforces invariants and defines the transaction scope. All modifications go through the root, and cross-Aggregate changes happen through events or eventual consistency, not multi-Aggregate transactions.

### Socratic Questions

- Your shopping cart has a `Cart` entity and `CartItem` entities. A business rule says the cart cannot exceed 50 items. Where should this rule be enforced, and what happens if a `CartItem` can be added without going through the `Cart`?
- You have an `Order` Aggregate and a `Payment` Aggregate. A teammate suggests wrapping the order creation and payment charge in a single database transaction to ensure both succeed or both fail. What is the DDD-aligned alternative, and why does Evans recommend it?
- Your `Invoice` Aggregate currently contains the full `Customer` entity with all their addresses and preferences. Loading an invoice pulls in hundreds of kilobytes of customer data. How would you redesign this Aggregate boundary?
