SELECT
    u.age,
    u.gender,
    u.state,
    u.postal_code,
    u.city,
    u.country,
    p.cost,
    p.category,
    p.name,
    p.brand,
     COALESCE(p.retail_price, oi.sale_price) AS retail_price,
	 COALESCE(p.retail_price, oi.sale_price) * o.num_of_item AS revenue,
    p.department,
    o.num_of_item,
    oi.status,
    oi.created_at,
    oi.shipped_at,
    oi.returned_at,
    oi.sale_price
FROM
    PortfolioProjects..thelook_ecommerce_users u
JOIN
    PortfolioProjects..thelook_ecommerce_orders o ON u.id = o.user_id
JOIN
    PortfolioProjects..thelook_ecommerce_order_items oi ON o.order_id = oi.order_id
JOIN
    PortfolioProjects..thelook_ecommerce_products p ON oi.product_id = p.id;






