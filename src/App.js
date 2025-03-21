import { HashRouter as Router, Routes, Route } from "react-router-dom";
import AppNavbar from "./components/AppNavbar";

import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';

import Home from "./pages/Home";
import Page1 from "./pages/Page1";
import Page2 from "./pages/Page2";
import Page3 from "./pages/Page3";

function App() {
  const lightTheme = createTheme({
    palette: {
      mode: 'light',
      
    },
  });
  
  return (
    <Router>
      <ThemeProvider theme={lightTheme}>
        <Box sx={{ display: 'flex' }}>
          <CssBaseline />
          <AppNavbar/>
          <Box component="main" sx={{ p: 2 }}>
            <Toolbar />
            <Routes>
              {/* Public Routes */}
              <Route path="/page1" element={<Page1/>} />
              <Route path="/page2" element={<Page2/>} />
              <Route path="/page3" element={<Page3/>} />           

              {/* Default Home Page */}
              <Route path="/" element={<Home/>} />
            </Routes>
          </Box>
        </Box>
      </ThemeProvider>
    </Router>
  );
}

export default App;
