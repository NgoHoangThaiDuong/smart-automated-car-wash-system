<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url var="addDefaultVehicleImage" value="/images/vehicles/car-default.svg"/>
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
    <label class="image-field">Vehicle Image
        <input id="addVehicleImage" type="file" name="vehicleImage"
               accept="image/jpeg,image/png,image/webp">
    </label>
</div>
<div class="vehicle-preview-wrapper">
    <img id="addImagePreview" src="${addDefaultVehicleImage}"
         alt="Vehicle preview" class="vehicle-preview-image">
</div>
