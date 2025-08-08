const ProductController = require('../controllers/productController');

const productController = new ProductController();

exports.handler = async (event) => {
  return await productController.getAllProducts(event);
};
