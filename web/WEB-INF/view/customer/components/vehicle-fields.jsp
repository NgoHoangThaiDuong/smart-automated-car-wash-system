<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="form-grid">
    <label>License Plate *
        <input id="addLicensePlate" type="text" name="licensePlate"
               maxlength="20" required placeholder="29A-12345"
               value="<c:out value='${vehicleFormMode eq "add" ? vehicleFormData.licensePlate : ""}'/>">
    </label>
    <label>Brand
        <input id="addBrand" type="text" name="brand" maxlength="50" placeholder="Toyota"
               value="<c:out value='${vehicleFormMode eq "add" ? vehicleFormData.brand : ""}'/>">
    </label>
    <label>Model
        <input id="addModel" type="text" name="model" maxlength="50" placeholder="Camry"
               value="<c:out value='${vehicleFormMode eq "add" ? vehicleFormData.model : ""}'/>">
    </label>
    <label>Color
        <input id="addColor" type="text" name="color" maxlength="30" placeholder="White"
               value="<c:out value='${vehicleFormMode eq "add" ? vehicleFormData.color : ""}'/>">
    </label>
</div>
