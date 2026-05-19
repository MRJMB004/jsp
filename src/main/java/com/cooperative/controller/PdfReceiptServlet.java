package com.cooperative.controller;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.model.Reservation;
import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.*;
import com.lowagie.text.pdf.draw.LineSeparator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.Color;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/reservation/pdf")
public class PdfReceiptServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Color COLOR_PRIMARY    = new Color(58, 91, 140);
    private static final Color COLOR_SECONDARY  = new Color(90, 127, 176);
    private static final Color COLOR_SUCCESS    = new Color(16, 185, 129);
    private static final Color COLOR_WARNING    = new Color(245, 158, 11);
    private static final Color COLOR_ERROR      = new Color(239, 68, 68);
    private static final Color COLOR_LIGHT_GRAY = new Color(245, 245, 245);
    private static final Color COLOR_WHITE      = Color.WHITE;
    private static final Color COLOR_BLACK      = Color.BLACK;
    private static final Color COLOR_GRAY       = Color.GRAY;
    private static final Color COLOR_LINE       = new Color(200, 200, 200);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de réservation manquant");
            return;
        }

        try {
            ReservationDAO dao = new ReservationDAO();
            Reservation reservation = dao.findByIdWithDetails(idParam);

            if (reservation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Réservation non trouvée");
                return;
            }

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "inline; filename=recu_" + reservation.getIdreserv() + ".pdf");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

            generatePdf(response, reservation);

        } catch (DocumentException e) {
            e.printStackTrace();
            throw new ServletException("Erreur génération PDF : " + e.getMessage(), e);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur inattendue : " + e.getMessage(), e);
        }
    }

    private void generatePdf(HttpServletResponse response, Reservation reservation)
            throws DocumentException, IOException {

        Document document = new Document(PageSize.A5, 36, 36, 36, 36);
        PdfWriter.getInstance(document, response.getOutputStream());

        document.addTitle("Reçu N° " + reservation.getIdreserv());
        document.addAuthor("Coopérative de Transport");
        document.addSubject("Reçu de réservation");
        document.addCreator("Système de Gestion Coopérative");
        document.addCreationDate();
        document.open();

        // ── Fonts ──
        Font titleFont       = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, COLOR_WHITE);
        Font normalFont      = FontFactory.getFont(FontFactory.HELVETICA, 10, COLOR_BLACK);
        Font boldFont        = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, COLOR_BLACK);
        Font smallFont       = FontFactory.getFont(FontFactory.HELVETICA, 8, COLOR_GRAY);
        Font successFont     = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, COLOR_SUCCESS);
        Font receiptNumFont  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, COLOR_SECONDARY);
        Font whiteSmallFont  = FontFactory.getFont(FontFactory.HELVETICA, 10, COLOR_WHITE);

        SimpleDateFormat dateFmt     = new SimpleDateFormat("dd MMMM yyyy");
        SimpleDateFormat dateTimeFmt = new SimpleDateFormat("dd MMMM yyyy 'à' HH:mm");

        // ── En-tête ──
        addHeader(document, titleFont, whiteSmallFont);

        // ── Numéro de reçu ──
        Paragraph receiptNumber = new Paragraph("Reçu N° " + reservation.getIdreserv(), receiptNumFont);
        receiptNumber.setAlignment(Element.ALIGN_CENTER);
        receiptNumber.setSpacingAfter(15);
        document.add(receiptNumber);

        // ── Informations de réservation ──
        document.add(createSectionHeader("Informations de réservation"));
        PdfPTable infoTable = createTwoColumnTable(new float[]{35, 65});
        addTableRow(infoTable, "Date réservation :",
                dateTimeFmt.format(reservation.getDateReserv()), normalFont, boldFont);
        addTableRow(infoTable, "Date du voyage :",
                dateFmt.format(reservation.getDateVoyage()), normalFont, boldFont);
        document.add(infoTable);

        // ── Client ──
        document.add(createSectionHeader("Client"));
        PdfPTable clientTable = createTwoColumnTable(new float[]{30, 70});
        addTableRow(clientTable, "Nom :", reservation.getNomClient(), normalFont, boldFont);
        addTableRow(clientTable, "Contact :", reservation.getNumtelClient(), normalFont, boldFont);
        document.add(clientTable);

        // ── Voyage — avec modèle + immatriculation + place ──
        document.add(createSectionHeader("Informations du voyage"));
        PdfPTable voyageTable = createTwoColumnTable(new float[]{40, 60});

        addTableRow(voyageTable, "Modèle :",
                reservation.getDesignVoiture(), normalFont, boldFont);

        // CORRECTION: Utilisation de getIdvoit() au lieu de getImmatriculationVoiture()
        String immat = reservation.getIdvoit();
        if (immat == null || immat.trim().isEmpty()) {
            immat = "Non renseignée";
        }
        addTableRow(voyageTable, "Immatriculation :", immat, normalFont,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, COLOR_PRIMARY));

        addTableRow(voyageTable, "Place N° :",
                String.valueOf(reservation.getPlace()), normalFont,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, COLOR_BLACK));
        document.add(voyageTable);

        // ── Paiement ──
        document.add(createSectionHeader("Détails du paiement"));

        PdfPTable paymentModeTable = createTwoColumnTable(new float[]{40, 60});
        addPaymentModeRow(paymentModeTable, "Mode de paiement :",
                reservation.getPayment(), normalFont);
        document.add(paymentModeTable);

        document.add(new Paragraph(" "));

        PdfPTable amountTable = createTwoColumnTable(new float[]{60, 40});
        addAmountRows(amountTable, reservation);
        document.add(amountTable);

        // ── Confirmation ──
        document.add(new Paragraph(" "));
        Paragraph confirmPara = new Paragraph();
        confirmPara.setAlignment(Element.ALIGN_CENTER);
        confirmPara.setSpacingBefore(20);
        confirmPara.add(new Chunk("✓ Réservation confirmée\n", successFont));
        confirmPara.add(new Chunk("\nMerci de votre confiance !\n", normalFont));
        confirmPara.add(new Chunk("Veuillez vous présenter 30 minutes avant le départ.", smallFont));
        document.add(confirmPara);

        // ── Pied de page ──
        addFooter(document, boldFont, smallFont);

        document.close();
    }

    // ─────────────────────────────── helpers ───────────────────────────────

    private void addHeader(Document document, Font titleFont, Font subtitleFont)
            throws DocumentException {
        PdfPTable headerTable = new PdfPTable(1);
        headerTable.setWidthPercentage(100);

        PdfPCell headerCell = new PdfPCell();
        headerCell.setBackgroundColor(COLOR_PRIMARY);
        headerCell.setPadding(20);
        headerCell.setBorder(Rectangle.NO_BORDER);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph headerPara = new Paragraph();
        headerPara.setAlignment(Element.ALIGN_CENTER);
        headerPara.add(new Chunk("COOPÉRATIVE DE TRANSPORT\n", titleFont));
        headerPara.add(new Chunk("Votre partenaire de voyage", subtitleFont));
        headerCell.addElement(headerPara);

        headerTable.addCell(headerCell);
        document.add(headerTable);
        document.add(new Paragraph(" "));
    }

    private void addFooter(Document document, Font boldFont, Font smallFont)
            throws DocumentException {
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(30);
        footer.add(new Chunk("Coopérative de Transport\n", boldFont));
        footer.add(new Chunk("Tel: +261 38 92 827 07 | Email: contact@cooperative.mg", smallFont));
        document.add(footer);
    }

    private Paragraph createSectionHeader(String title) {
        Paragraph header = new Paragraph();
        header.setSpacingBefore(10);
        header.setSpacingAfter(8);
        header.add(new Chunk(title,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, COLOR_SECONDARY)));
        LineSeparator line = new LineSeparator();
        line.setLineColor(COLOR_LINE);
        line.setLineWidth(0.5f);
        header.add(new Chunk(line));
        return header;
    }

    private PdfPTable createTwoColumnTable(float[] widths) {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(widths);
        table.setSpacingAfter(10);
        return table;
    }

    private void addTableRow(PdfPTable table, String label, String value,
                             Font labelFont, Font valueFont) {
        PdfPCell cell1 = new PdfPCell(new Phrase(label, labelFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(3);
        table.addCell(cell1);

        PdfPCell cell2 = new PdfPCell(new Phrase(value != null ? value : "-", valueFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(3);
        table.addCell(cell2);
    }

    private void addPaymentModeRow(PdfPTable table, String label, String value, Font labelFont) {
        PdfPCell cell1 = new PdfPCell(new Phrase(label, labelFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        table.addCell(cell1);

        PdfPCell cell2 = new PdfPCell();
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);

        Color paymentColor;
        if ("avec avance".equals(value))  paymentColor = COLOR_WARNING;
        else if ("tout payé".equals(value)) paymentColor = COLOR_SUCCESS;
        else                               paymentColor = COLOR_ERROR;

        cell2.addElement(new Chunk(value,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, paymentColor)));
        table.addCell(cell2);
    }

    private void addAmountRows(PdfPTable table, Reservation reservation) {
        PdfPCell label1 = createAmountCell("Frais total :", COLOR_LIGHT_GRAY, Element.ALIGN_LEFT);
        PdfPCell value1 = createAmountCell(
                String.format("%,d Ar", reservation.getFraisVoiture()),
                COLOR_LIGHT_GRAY, Element.ALIGN_RIGHT);
        table.addCell(label1);
        table.addCell(value1);

        if ("avec avance".equals(reservation.getPayment())) {
            int reste = reservation.getFraisVoiture() - reservation.getMontantAvance();

            table.addCell(createAmountCell("Montant avance :", null, Element.ALIGN_LEFT));
            table.addCell(createAmountCell(
                    String.format("%,d Ar", reservation.getMontantAvance()),
                    null, Element.ALIGN_RIGHT));

            PdfPCell l3 = createAmountCell("Reste à payer :", COLOR_LIGHT_GRAY, Element.ALIGN_LEFT);
            PdfPCell v3 = createAmountCell(
                    String.format("%,d Ar", reste), COLOR_LIGHT_GRAY, Element.ALIGN_RIGHT);
            l3.setBorder(Rectangle.TOP);
            v3.setBorder(Rectangle.TOP);
            table.addCell(l3);
            table.addCell(v3);

        } else if ("tout payé".equals(reservation.getPayment())) {
            PdfPCell l2 = createAmountCell("Montant payé :", COLOR_LIGHT_GRAY, Element.ALIGN_LEFT);
            PdfPCell v2 = createAmountCell(
                    String.format("%,d Ar", reservation.getFraisVoiture()),
                    COLOR_LIGHT_GRAY, Element.ALIGN_RIGHT);
            l2.setBorder(Rectangle.TOP);
            v2.setBorder(Rectangle.TOP);
            table.addCell(l2);
            table.addCell(v2);

        } else {
            PdfPCell l2 = createAmountCell("À payer :", COLOR_LIGHT_GRAY, Element.ALIGN_LEFT);
            PdfPCell v2 = createAmountCell(
                    String.format("%,d Ar", reservation.getFraisVoiture()),
                    COLOR_LIGHT_GRAY, Element.ALIGN_RIGHT);
            l2.setBorder(Rectangle.TOP);
            v2.setBorder(Rectangle.TOP);
            table.addCell(l2);
            table.addCell(v2);
        }
    }

    private PdfPCell createAmountCell(String text, Color bg, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(text,
                FontFactory.getFont(FontFactory.HELVETICA, 10)));
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(8);
        cell.setHorizontalAlignment(alignment);
        if (bg != null) cell.setBackgroundColor(bg);
        return cell;
    }
}