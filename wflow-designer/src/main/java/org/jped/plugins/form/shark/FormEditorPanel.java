package org.jped.plugins.form.shark;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.EventObject;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import javax.swing.Action;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.Icon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextPane;
import javax.swing.JViewport;
import javax.swing.ListCellRenderer;
import javax.swing.UIManager;
import javax.swing.border.EmptyBorder;
import javax.swing.event.CellEditorListener;
import javax.swing.event.ChangeEvent;
import javax.swing.event.EventListenerList;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import org.enhydra.jawe.JaWEManager;
import org.enhydra.jawe.base.panel.PanelContainer;
import org.enhydra.jawe.base.panel.panels.XMLBasicPanel;
import org.enhydra.shark.xpdl.XMLUtil;
import org.enhydra.shark.xpdl.elements.Activity;
import org.enhydra.shark.xpdl.elements.DataField;
import org.enhydra.shark.xpdl.elements.DataFields;
import org.enhydra.shark.xpdl.elements.ExtendedAttribute;
import org.enhydra.shark.xpdl.elements.ExtendedAttributes;
import org.enhydra.shark.xpdl.elements.FormalParameter;
import org.enhydra.shark.xpdl.elements.FormalParameters;
import org.enhydra.shark.xpdl.elements.WorkflowProcess;

public class FormEditorPanel extends XMLBasicPanel {

    private class FieldNameRenderer extends JLabel
            implements TableCellRenderer {

        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
            setText((String) value);
            if (isSelected) {
                setBackground(new Color(185, 191, 219));
            } else {
                setBackground(table.getBackground());
            }
            return this;
        }

        public FieldNameRenderer() {
            super();
            setOpaque(true);
            setVerticalAlignment(1);
        }
    }

    private class DescriptionRenderer extends JTextPane
            implements TableCellRenderer {

        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
            setText((String) value);
            setSize(250, 32767);
            if (table.getRowHeight(row) < getPreferredSize().height) {
                table.setRowHeight(row, getPreferredSize().height);
            }
            if (isSelected) {
                setBackground(table.getSelectionBackground());
            } else {
                setBackground(table.getBackground());
            }
            return this;
        }

        public DescriptionRenderer() {
            super();
            setContentType("text/html");
            setOpaque(true);
        }
    }

    private class IconRenderer extends JLabel
            implements TableCellRenderer {

        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
            Icon icon = (Icon) value;
            setIcon(icon);
            setPreferredSize(new Dimension(icon.getIconWidth(), icon.getIconHeight()));
            if (table.getRowHeight(row) < icon.getIconHeight() + 5) {
                table.setRowHeight(row, icon.getIconHeight() + 5);
            }
            if (isSelected) {
                setBackground(table.getSelectionBackground());
            } else {
                setBackground(table.getBackground());
            }
            setOpaque(true);
            setAlignmentX(0.5F);
            return this;
        }

        private IconRenderer() {
            super();
        }
    }

    private class BooleanSelector extends JCheckBox
            implements TableCellEditor {

        public Component getTableCellEditorComponent(JTable table, Object value, boolean isSelected, int row, int column) {
            setSelected(((Boolean) value).booleanValue());
            this.row = row;
            this.column = column;
            return this;
        }

        protected void fireEditingStopped() {
            Object listeners[] = listenerList.getListenerList();
            for (int i = 0; i < listeners.length; i++) {
                //if (listeners[i] == (FormEditorPanel.class$javax$swing$event$CellEditorListener != null ? FormEditorPanel.class$javax$swing$event$CellEditorListener : (FormEditorPanel.class$javax$swing$event$CellEditorListener = FormEditorPanel._mthclass$("javax.swing.event.CellEditorListener")))) {
                //     CellEditorListener listener = (CellEditorListener) listeners[i + 1];
                //    listener.editingStopped(changeEvent);
                //}
            }

        }

        protected void fireEditingCanceled() {
            Object listeners[] = listenerList.getListenerList();
            for (int i = 0; i < listeners.length; i++) {
                //if (listeners[i] == (FormEditorPanel.class$javax$swing$event$CellEditorListener != null ? FormEditorPanel.class$javax$swing$event$CellEditorListener : (FormEditorPanel.class$javax$swing$event$CellEditorListener = FormEditorPanel._mthclass$("javax.swing.event.CellEditorListener")))) {
                //    CellEditorListener listener = (CellEditorListener) listeners[i + 1];
                //listener.editingCanceled(changeEvent);
                //}
            }

        }

        public void cancelCellEditing() {
            fireEditingCanceled();
        }

        public boolean stopCellEditing() {
            fireEditingStopped();
            return true;
        }

        public Object getCellEditorValue() {
            return new Boolean(isSelected());
        }

        public boolean isCellEditable(EventObject anEvent) {
            return true;
        }

        public boolean shouldSelectCell(EventObject anEvent) {
            return true;
        }

        public void addCellEditorListener(CellEditorListener l) {
            //listenerList.add(FormEditorPanel.class$javax$swing$event$CellEditorListener != null ? FormEditorPanel.class$javax$swing$event$CellEditorListener : (FormEditorPanel.class$javax$swing$event$CellEditorListener = FormEditorPanel._mthclass$("javax.swing.event.CellEditorListener")), l);
        }

        public void removeCellEditorListener(CellEditorListener l) {
            //.remove(FormEditorPanel.class$javax$swing$event$CellEditorListener != null ? FormEditorPanel.class$javax$swing$event$CellEditorListener : (FormEditorPanel.class$javax$swing$event$CellEditorListener = FormEditorPanel._mthclass$("javax.swing.event.CellEditorListener")), l);
        }
        protected EventListenerList listenerList;
        protected ChangeEvent changeEvent;
        private int row;
        private int column;

        public BooleanSelector() {
            super();
            listenerList = new EventListenerList();
            changeEvent = new ChangeEvent(this);
            addActionListener(new ActionListener() {

                public void actionPerformed(ActionEvent e) {
                    setText(isSelected() ? Messages.getString("FormEditor.Editable") : Messages.getString("FormEditor.Readonly"));
                    form.setValueAt(new Boolean(isSelected()), row, column);
                    getPanelContainer().panelChanged(FormEditorPanel.this, e);
                }
            });
        }
    }

    private class BooleanRenderer extends JCheckBox
            implements TableCellRenderer {

        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
            setSelected(((Boolean) value).booleanValue());
            setText(isSelected() ? Messages.getString("FormEditor.Editable") : Messages.getString("FormEditor.Readonly"));
            setOpaque(true);
            setBackground(Color.LIGHT_GRAY);
            return this;
        }

        private BooleanRenderer() {
            super();
        }
    }

    private class FormTableModel extends AbstractTableModel {

        public void toAttributes(ExtendedAttributes attributes) {
            ArrayList childs = attributes.toElements();
            Iterator i = childs.iterator();
            do {
                if (!i.hasNext()) {
                    break;
                }
                ExtendedAttribute attribute = (ExtendedAttribute) i.next();
                if ("VariableToProcess_UPDATE".equals(attribute.getName()) || "VariableToProcess_VIEW".equals(attribute.getName())) {
                    attributes.remove(attribute);
                }
            } while (true);
            childs.clear();
            ExtendedAttribute attribute;
            for (i = formItems.iterator(); i.hasNext(); childs.add(attribute)) {
                DataField f = (DataField) i.next();
                attribute = new ExtendedAttribute(attributes);
                attribute.setVValue(f.getId());
                if (isFieldActive(f)) {
                    attribute.setName("VariableToProcess_UPDATE");
                } else {
                    attribute.setName("VariableToProcess_VIEW");
                }
            }

            attributes.addAll(childs);
        }

        protected boolean isFieldActive(DataField field) {
            return activeField.contains(field);
        }

        protected void setFieldActive(DataField field, boolean active) {
            if (!active) {
                activeField.remove(field);
            } else {
                activeField.add(field);
            }
        }

        public int getColumnCount() {
            return 2;
        }

        public int getRowCount() {
            return formItems.size();
        }

        public Object getValueAt(int rowIndex, int columnIndex) {
            DataField field = (DataField) formItems.get(rowIndex);
            switch (columnIndex) {
                case 0: // '\0'
                    //String name = JaWEManager.getInstance().getJaWEController().getFilteredProperty(field, "Name");
                    //return name != null && name.length() >= 1 ? name : field.getId();
                    return field.getId();
                case 1: // '\003'
                    return new Boolean(isFieldActive(field));
            }
            throw new IndexOutOfBoundsException("Colomun index " + columnIndex + " is too high");
        }

        public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
            if (columnIndex == 1 && (aValue instanceof Boolean)) {
                setFieldActive((DataField) formItems.get(rowIndex), ((Boolean) aValue).booleanValue());
            }
        }

        public String getColumnName(int column) {
            switch (column) {
                case 0: // '\0'
                    return "Name";

                case 1: // '\003'
                    return "Editable?";
            }
            return null;
        }

        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return columnIndex == 1;
        }

        protected int addField(DataField field) {
            if (!formItems.contains(field)) {
                formItems.add(field);
                descriptions.put(field, JaWEManager.getInstance().getJaWEController().getFilteredProperty(field, "Description"));
                fireTableRowsInserted(formItems.size() - 1, formItems.size());
                return formItems.size() - 1;
            } else {
                return formItems.indexOf(field);
            }
        }

        protected void removeField(int index) {
            if (formItems.size() >= index) {
                Object o = formItems.remove(index);
                descriptions.remove(o);
                fireTableRowsDeleted(index, index);
            }
        }

        protected int moveUp(int index) {
            if (index <= 0 || index >= formItems.size()) {
                return 0;
            } else {
                Object o = formItems.remove(index);
                formItems.add(index - 1, o);
                fireTableRowsUpdated(index - 1, index);
                return index - 1;
            }
        }

        protected int moveDown(int index) {
            if (index < 0 || index >= formItems.size() - 1) {
                return formItems.size() - 1;
            } else {
                Object o = formItems.remove(index);
                formItems.add(index + 1, o);
                fireTableRowsUpdated(index, index + 1);
                return index + 1;
            }
        }
        private java.util.List formItems;
        private Set activeField;
        private Map descriptions;

        public FormTableModel(DataField fields[], ExtendedAttributes attributes, FormalParameters fps) {
            super();
            formItems = new ArrayList();
            activeField = new HashSet();
            descriptions = new HashMap();
            Map fieldMap = new HashMap();

            //add workflow varaibles
            for (int i = 0; i < fields.length; i++) {
                fieldMap.put(fields[i].getId(), fields[i]);
                addField(fields[i]);
            }

            //add formal parameters to formItems
            ArrayList fpList = fps.toElements();
            Iterator fpIte = fpList.iterator();
            do {
                if (!fpIte.hasNext()) {
                    break;
                }
                FormalParameter fp = (FormalParameter) fpIte.next();
                DataField f = new DataField(new DataFields((WorkflowProcess) fps.getParent()));
                f.setId(fp.getId());
                fieldMap.put(fp.getId(), f);
                addField(f);
            } while (true);

            //set field active
            ArrayList childs = attributes.toElements();
            Iterator i = childs.iterator();
            do {
                if (!i.hasNext()) {
                    break;
                }
                ExtendedAttribute attribute = (ExtendedAttribute) i.next();
                if ("VariableToProcess_UPDATE".equals(attribute.getName())) {
                    DataField f = (DataField) fieldMap.get(attribute.getVValue());
                    if (f != null) {
                        addField(f);
                        setFieldActive(f, true);
                    }
                } else if ("VariableToProcess_VIEW".equals(attribute.getName())) {
                    DataField f = (DataField) fieldMap.get(attribute.getVValue());
                    if (f != null) {
                        addField(f);
                        setFieldActive(f, false);
                    }
                }
            } while (true);
        }
    }

    private class DataFieldRenderer extends JPanel
            implements ListCellRenderer {

        public Component getListCellRendererComponent(JList list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
            DataField field = (DataField) value;
//            if (field.getName() == null || field.getName().length() == 0) {
//                content.setText(field.getId());
//            } else {
//                content.setText(field.getName());
//            }
            content.setText(field.getId());
            content.setIcon(getFieldIcon(field));
            content.setVerticalTextPosition(1);
            content.setHorizontalTextPosition(0);
            if (isSelected) {
                setForeground(list.getSelectionForeground());
                setBackground(list.getSelectionBackground());
            } else {
                setForeground(list.getForeground());
                setBackground(FormEditorPanel.ROW_COLORS[index % FormEditorPanel.ROW_COLORS.length]);
            }
            return this;
        }
        JLabel content;

        public DataFieldRenderer() {
            super();
            content = new JLabel();
            add(content);
            setBorder(new EmptyBorder(5, 5, 5, 5));
            setOpaque(true);
            content.setOpaque(false);
        }
    }

    public FormEditorPanel(PanelContainer pc, Activity activity, boolean isVertical, boolean hasBorder, boolean hasEmptyBorder) {
        super(pc, activity, Messages.getString("FormEditor.title"), isVertical, hasBorder, hasEmptyBorder);
        formManager = new FormManager();
        addAction = new AbstractAction("FormEditor.Add") {

            public void actionPerformed(ActionEvent e) {
                DataField field = (DataField) availableDatas.getSelectedValue();
                if (field != null) {
                    int location = formTableModel.addField(field);
                    form.setRowSelectionInterval(location, location);
                    getPanelContainer().panelChanged(FormEditorPanel.this, e);
                }
            }
        };
        removeAction = new AbstractAction("FormEditor.Remove") {

            public void actionPerformed(ActionEvent e) {
                formTableModel.removeField(form.getSelectedRow());
                getPanelContainer().panelChanged(FormEditorPanel.this, e);
            }
        };
        upAction = new AbstractAction("FormEditor.Up") {

            public void actionPerformed(ActionEvent e) {
                int row = formTableModel.moveUp(form.getSelectedRow());
                form.setRowSelectionInterval(row, row);
                getPanelContainer().panelChanged(FormEditorPanel.this, e);
            }
        };
        downAction = new AbstractAction("FormEditor.Down") {

            public void actionPerformed(ActionEvent e) {
                int row = formTableModel.moveDown(form.getSelectedRow());
                form.setRowSelectionInterval(row, row);
                getPanelContainer().panelChanged(FormEditorPanel.this, e);
            }
        };
        this.activity = activity;
        workflowDatas = new LinkedHashMap();
        WorkflowProcess process = (WorkflowProcess) activity.getParent().getParent();
        Map m = XMLUtil.getPossibleDataFields(process);
        DataField dataFields[] = (DataField[]) (DataField[]) m.values().toArray(new DataField[0]);
        for (int i = 0; i < dataFields.length; i++) {
            //workflowDatas.put(dataFields[i].getName(), dataFields[i]);
            workflowDatas.put(dataFields[i].getId(), dataFields[i]);
        }

        FormalParameters fps = process.getFormalParameters();
        initComponents(activity.getExtendedAttributes(), dataFields, fps);
    }

    public void setElements() {
        formTableModel.toAttributes(activity.getExtendedAttributes());
    }

    private void initComponents(ExtendedAttributes attributes, DataField workflowDatas[], FormalParameters fps) {
        availableDatas = new JList(workflowDatas) {

            public String getToolTipText(MouseEvent evt) {
                int index = locationToIndex(evt.getPoint());
                DataField item = (DataField) getModel().getElementAt(index);
                if (item == null) {
                    return "";
                } else {
                    return JaWEManager.getInstance().getTooltipGenerator().getTooltip(item);
                }
            }
        };
        availableDatas.setCellRenderer(new DataFieldRenderer());
        availableDatas.setSelectionMode(0);
        formTableModel = new FormTableModel(workflowDatas, attributes, fps);
        form = new JTable(formTableModel) {

            protected void configureEnclosingScrollPane() {
                Container p = getParent();
                if (p instanceof JViewport) {
                    Container gp = p.getParent();
                    if (gp instanceof JScrollPane) {
                        JScrollPane scrollPane = (JScrollPane) gp;
                        JViewport viewport = scrollPane.getViewport();
                        if (viewport == null || viewport.getView() != this) {
                            return;
                        }
                        scrollPane.getViewport().setScrollMode(2);
                        scrollPane.setBorder(UIManager.getBorder("Table.scrollPaneBorder"));
                    }
                }
            }
        };
        form.setRowSelectionAllowed(true);
        form.getColumnModel().getColumn(0).setCellRenderer(new FieldNameRenderer());
        form.getColumnModel().getColumn(0).setMinWidth(300);
        form.getColumnModel().getColumn(1).setCellEditor(new BooleanSelector());
        form.getColumnModel().getColumn(1).setCellRenderer(new BooleanRenderer());
        form.getColumnModel().getColumn(1).setMinWidth(100);
        form.setShowGrid(false);
        form.setRowMargin(5);
        form.setRowHeight(30);
        form.setBackground(Color.WHITE);
        JTextPane head = new JTextPane();
        JButton addButton = new JButton(addAction);
        JButton removeButton = new JButton(removeAction);
        JButton upButton = new JButton(upAction);
        JButton downButton = new JButton(downAction);
        JPanel mainPanel = new JPanel();
        JPanel rightPanel = new JPanel();
        JPanel rightButtons = new JPanel();
        JPanel navigation = new JPanel();
        JScrollPane js = new JScrollPane(availableDatas);
        setLayout(new BorderLayout());
        mainPanel.setLayout(new BoxLayout(mainPanel, 2));
        rightPanel.setLayout(new BoxLayout(rightPanel, 3));
        rightButtons.setLayout(new BoxLayout(rightButtons, 2));
        navigation.setLayout(new BoxLayout(navigation, 3));
        rightButtons.setAlignmentX(1.0F);
        addButton.setAlignmentY(0.0F);
        removeButton.setAlignmentY(0.0F);
        add(head, "North");
        add(mainPanel, "Center");
        mainPanel.add(rightPanel);
        form.setAutoResizeMode(0);
        rightPanel.add(new JScrollPane(form));
        rightButtons.add(removeButton);
        rightButtons.add(addButton);
        rightButtons.add(Box.createHorizontalGlue());
        rightButtons.add(navigation);
        navigation.add(upButton);
        navigation.add(downButton);
        rightPanel.setMinimumSize(new Dimension(650, 300));
        rightPanel.setPreferredSize(new Dimension(650, 300));
        head.setText(Messages.getString("FormEditor.description"));
        head.setOpaque(false);
        head.setEditable(false);
        addAction.setEnabled(false);
        removeAction.setEnabled(false);
        upAction.setEnabled(false);
        downAction.setEnabled(false);
        availableDatas.addListSelectionListener(new ListSelectionListener() {

            public void valueChanged(ListSelectionEvent e) {
                addAction.setEnabled(((JList) e.getSource()).getSelectedIndex() != -1);
            }
        });
        ListSelectionListener listener = new ListSelectionListener() {

            public void valueChanged(ListSelectionEvent e) {
                JTable src = form;
                int row = src.getSelectedRow();
                downAction.setEnabled(row > -1 && row < src.getRowCount() - 1);
                upAction.setEnabled(row > 0);
                removeAction.setEnabled(row > -1);
            }
        };
        form.getSelectionModel().addListSelectionListener(listener);
        form.getColumnModel().getSelectionModel().addListSelectionListener(listener);
    }

    protected Icon getFieldIcon(DataField field) {
        return formManager.getFieldIcon(field);
    }
    private static final int ROW_MARGIN = 5;
    private static final Color ROW_COLORS[];
    private static final String ATTRIBUTE_READONLY = "VariableToProcess_VIEW";
    private static final String ATTRIBUTE_READWRITE = "VariableToProcess_UPDATE";
    private Map workflowDatas;
    private JList availableDatas;
    private JTable form;
    private FormTableModel formTableModel;
    private FormManager formManager;
    private Activity activity;
    protected Action addAction;
    protected Action removeAction;
    protected Action upAction;
    protected Action downAction;

    static {
        ROW_COLORS = (new Color[]{
                    Color.WHITE, Color.LIGHT_GRAY
                });
    }
}
