<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Entry - Order_Master</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 0; padding: 40px; }
        .card {
            max-width: 420px; margin: auto; background: #fff; padding: 30px;
            border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h2 { margin-top: 0; color: #333; }
        label { display: block; margin-top: 14px; font-weight: bold; color: #555; font-size: 14px; }
        input[type="text"], input[type="number"] {
            width: 100%; padding: 8px; margin-top: 4px; box-sizing: border-box;
            border: 1px solid #ccc; border-radius: 4px;
        }
        input[readonly] { background: #eee; }
        .row { display: flex; gap: 8px; align-items: flex-end; }
        .row input { flex: 1; }
        button {
            margin-top: 6px; padding: 8px 14px; border: none; border-radius: 4px;
            background: #2563eb; color: #fff; cursor: pointer; font-size: 14px;
        }
        button:hover { background: #1d4ed8; }
        #saveBtn { margin-top: 18px; width: 100%; background: #16a34a; }
        #saveBtn:hover { background: #15803d; }
        #clearBtn { margin-top: 8px; width: 100%; background: #6b7280; }
        #clearBtn:hover { background: #4b5563; }
        #status { margin-top: 16px; font-size: 14px; min-height: 20px; }
        .ok { color: #16a34a; }
        .err { color: #dc2626; }
    </style>
</head>
<body>

<div class="card">
    <h2>Order Entry</h2>

    <label for="prodName">Product Name</label>
    <div class="row">
        <input type="text" id="prodName" placeholder="e.g. Laptop">
        <button onclick="validateProduct()">Validate</button>
    </div>

    <label for="rate">Rate</label>
    <input type="text" id="rate" readonly>

    <label for="availableQty">Available Qty</label>
    <input type="text" id="availableQty" readonly>

    <label for="orderQty">Order Qty</label>
    <input type="number" id="orderQty" min="1" oninput="previewValue()">

    <label for="orderValue">Order Value</label>
    <input type="text" id="orderValue" readonly>

    <button id="saveBtn" onclick="saveOrder()">Save Order</button>
    <button id="clearBtn" onclick="clearForm()">Clear</button>

    <div id="status"></div>
</div>

<script>
    let validatedProdId = null;
    let validatedRate = 0;
    let validatedQty = 0;

    function showStatus(msg, isError) {
        const el = document.getElementById('status');
        el.textContent = msg;
        el.className = isError ? 'err' : 'ok';
    }

    function validateProduct() {
        const name = document.getElementById('prodName').value.trim();
        if (!name) {
            showStatus('Enter a product name first.', true);
            return;
        }

        fetch('ValidateProductServlet?name=' + encodeURIComponent(name))
            .then(res => res.json())
            .then(data => {
                if (data.found) {
                    validatedProdId = data.prodId;
                    validatedRate = data.rate;
                    validatedQty = data.qty;

                    document.getElementById('rate').value = data.rate;
                    document.getElementById('availableQty').value = data.qty;
                    showStatus('Product found. Rate & available qty loaded.', false);
                } else {
                    validatedProdId = null;
                    document.getElementById('rate').value = '';
                    document.getElementById('availableQty').value = '';
                    showStatus('Product not found in Product_Master.', true);
                }
            })
            .catch(err => showStatus('Request failed: ' + err, true));
    }

    function previewValue() {
        if (validatedProdId === null) return;
        const qty = parseInt(document.getElementById('orderQty').value);
        if (!isNaN(qty)) {
            document.getElementById('orderValue').value = (qty * validatedRate).toFixed(2);
        } else {
            document.getElementById('orderValue').value = '';
        }
    }

    function saveOrder() {
        if (validatedProdId === null) {
            showStatus('Validate the product before saving.', true);
            return;
        }

        const qty = parseInt(document.getElementById('orderQty').value);
        if (isNaN(qty) || qty <= 0) {
            showStatus('Enter a valid quantity.', true);
            return;
        }
        if (qty > validatedQty) {
            showStatus('Order qty exceeds available stock (' + validatedQty + ').', true);
            return;
        }

        const params = new URLSearchParams();
        params.append('prodId', validatedProdId);
        params.append('qty', qty);

        fetch('SaveOrderServlet', { method: 'POST', body: params })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('orderValue').value = data.orderValue.toFixed(2);
                    showStatus('Order saved! OrderID = ' + data.orderId + ' | OrderValue = ' + data.orderValue, false);
                } else {
                    showStatus(data.message, true);
                }
            })
            .catch(err => showStatus('Request failed: ' + err, true));
    }

    function clearForm() {
        document.getElementById('prodName').value = '';
        document.getElementById('rate').value = '';
        document.getElementById('availableQty').value = '';
        document.getElementById('orderQty').value = '';
        document.getElementById('orderValue').value = '';
        validatedProdId = null;
        showStatus('', false);
    }
</script>

</body>
</html>
