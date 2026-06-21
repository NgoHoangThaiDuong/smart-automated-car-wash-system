package controller;

import mylib.VehicleImageStorage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/vehicle-images/*")
public class VehicleImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String filename = pathInfo == null || pathInfo.length() <= 1
                ? null : pathInfo.substring(1);
        Path image = VehicleImageStorage.resolveFile(filename);

        if (image == null || !Files.isRegularFile(image)) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        res.setContentType(VehicleImageStorage.contentTypeForFilename(filename));
        res.setContentLengthLong(Files.size(image));
        res.setHeader("X-Content-Type-Options", "nosniff");
        Files.copy(image, res.getOutputStream());
    }
}
