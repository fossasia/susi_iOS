/*************************************************************************
 *
 * Copyright 2016 Realm Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **************************************************************************/

#ifndef REALM_TABLE_MACROS_HPP
#define REALM_TABLE_MACROS_HPP

#include <realm/table_basic.hpp>

/*****************************************************************************
 *                                                                           *
 *      THIS INTERFACE IS DEPRECATED AND MAY BE REMOVED WITHOUT NOTICE       *
 *                                                                           *
 ****************************************************************************/

// clang-format off

#define REALM_TABLE_1(Table, name1, type1) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        ColNames(Init i) noexcept: name1(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1)); \
        } \
        void insert(size_t _realm_i, type1 name1) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1)); \
        } \
        void set(size_t _realm_i, type1 name1) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_2(Table, name1, type1, name2, type2) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        ColNames(Init i) noexcept: name1(i), name2(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_3(Table, name1, type1, name2, type2, name3, type3) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_4(Table, name1, type1, name2, type2, name3, type3, name4, type4) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_5(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_6(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_7(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_8(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_9(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_10(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9, name10, type10) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns9; \
    typedef ::realm::util::TypeAppend< Columns9, type10 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        typename Col<9>::type name10; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i), name10(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
        names[9] = realm::StringData(#name10, sizeof #name10 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_11(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9, name10, type10, name11, type11) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns9; \
    typedef ::realm::util::TypeAppend< Columns9, type10 >::type Columns10; \
    typedef ::realm::util::TypeAppend< Columns10, type11 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        typename Col<9>::type name10; \
        typename Col<10>::type name11; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i), name10(i), name11(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
        names[9] = realm::StringData(#name10, sizeof #name10 - 1); \
        names[10] = realm::StringData(#name11, sizeof #name11 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_12(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9, name10, type10, name11, type11, name12, type12) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns9; \
    typedef ::realm::util::TypeAppend< Columns9, type10 >::type Columns10; \
    typedef ::realm::util::TypeAppend< Columns10, type11 >::type Columns11; \
    typedef ::realm::util::TypeAppend< Columns11, type12 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        typename Col<9>::type name10; \
        typename Col<10>::type name11; \
        typename Col<11>::type name12; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i), name10(i), name11(i), name12(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
        names[9] = realm::StringData(#name10, sizeof #name10 - 1); \
        names[10] = realm::StringData(#name11, sizeof #name11 - 1); \
        names[11] = realm::StringData(#name12, sizeof #name12 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_13(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9, name10, type10, name11, type11, name12, type12, name13, type13) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns9; \
    typedef ::realm::util::TypeAppend< Columns9, type10 >::type Columns10; \
    typedef ::realm::util::TypeAppend< Columns10, type11 >::type Columns11; \
    typedef ::realm::util::TypeAppend< Columns11, type12 >::type Columns12; \
    typedef ::realm::util::TypeAppend< Columns12, type13 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        typename Col<9>::type name10; \
        typename Col<10>::type name11; \
        typename Col<11>::type name12; \
        typename Col<12>::type name13; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i), name10(i), name11(i), name12(i), name13(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
        names[9] = realm::StringData(#name10, sizeof #name10 - 1); \
        names[10] = realm::StringData(#name11, sizeof #name11 - 1); \
        names[11] = realm::StringData(#name12, sizeof #name12 - 1); \
        names[12] = realm::StringData(#name13, sizeof #name13 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_14(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9, name10, type10, name11, type11, name12, type12, name13, type13, name14, type14) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns9; \
    typedef ::realm::util::TypeAppend< Columns9, type10 >::type Columns10; \
    typedef ::realm::util::TypeAppend< Columns10, type11 >::type Columns11; \
    typedef ::realm::util::TypeAppend< Columns11, type12 >::type Columns12; \
    typedef ::realm::util::TypeAppend< Columns12, type13 >::type Columns13; \
    typedef ::realm::util::TypeAppend< Columns13, type14 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        typename Col<9>::type name10; \
        typename Col<10>::type name11; \
        typename Col<11>::type name12; \
        typename Col<12>::type name13; \
        typename Col<13>::type name14; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i), name10(i), name11(i), name12(i), name13(i), name14(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
        names[9] = realm::StringData(#name10, sizeof #name10 - 1); \
        names[10] = realm::StringData(#name11, sizeof #name11 - 1); \
        names[11] = realm::StringData(#name12, sizeof #name12 - 1); \
        names[12] = realm::StringData(#name13, sizeof #name13 - 1); \
        names[13] = realm::StringData(#name14, sizeof #name14 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13, type14 name14) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13, type14 name14) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13, type14 name14) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


#define REALM_TABLE_15(Table, name1, type1, name2, type2, name3, type3, name4, type4, name5, type5, name6, type6, name7, type7, name8, type8, name9, type9, name10, type10, name11, type11, name12, type12, name13, type13, name14, type14, name15, type15) \
struct Table##Spec: ::realm::SpecBase { \
    typedef ::realm::util::TypeAppend< void,     type1 >::type Columns1; \
    typedef ::realm::util::TypeAppend< Columns1, type2 >::type Columns2; \
    typedef ::realm::util::TypeAppend< Columns2, type3 >::type Columns3; \
    typedef ::realm::util::TypeAppend< Columns3, type4 >::type Columns4; \
    typedef ::realm::util::TypeAppend< Columns4, type5 >::type Columns5; \
    typedef ::realm::util::TypeAppend< Columns5, type6 >::type Columns6; \
    typedef ::realm::util::TypeAppend< Columns6, type7 >::type Columns7; \
    typedef ::realm::util::TypeAppend< Columns7, type8 >::type Columns8; \
    typedef ::realm::util::TypeAppend< Columns8, type9 >::type Columns9; \
    typedef ::realm::util::TypeAppend< Columns9, type10 >::type Columns10; \
    typedef ::realm::util::TypeAppend< Columns10, type11 >::type Columns11; \
    typedef ::realm::util::TypeAppend< Columns11, type12 >::type Columns12; \
    typedef ::realm::util::TypeAppend< Columns12, type13 >::type Columns13; \
    typedef ::realm::util::TypeAppend< Columns13, type14 >::type Columns14; \
    typedef ::realm::util::TypeAppend< Columns14, type15 >::type Columns; \
 \
    template<template<int> class Col, class Init> \
    struct ColNames { \
        typename Col<0>::type name1; \
        typename Col<1>::type name2; \
        typename Col<2>::type name3; \
        typename Col<3>::type name4; \
        typename Col<4>::type name5; \
        typename Col<5>::type name6; \
        typename Col<6>::type name7; \
        typename Col<7>::type name8; \
        typename Col<8>::type name9; \
        typename Col<9>::type name10; \
        typename Col<10>::type name11; \
        typename Col<11>::type name12; \
        typename Col<12>::type name13; \
        typename Col<13>::type name14; \
        typename Col<14>::type name15; \
        ColNames(Init i) noexcept: name1(i), name2(i), name3(i), name4(i), name5(i), name6(i), name7(i), name8(i), name9(i), name10(i), name11(i), name12(i), name13(i), name14(i), name15(i) {} \
    }; \
 \
    static void dyn_col_names(realm::StringData* names) noexcept \
    { \
        names[0] = realm::StringData(#name1, sizeof #name1 - 1); \
        names[1] = realm::StringData(#name2, sizeof #name2 - 1); \
        names[2] = realm::StringData(#name3, sizeof #name3 - 1); \
        names[3] = realm::StringData(#name4, sizeof #name4 - 1); \
        names[4] = realm::StringData(#name5, sizeof #name5 - 1); \
        names[5] = realm::StringData(#name6, sizeof #name6 - 1); \
        names[6] = realm::StringData(#name7, sizeof #name7 - 1); \
        names[7] = realm::StringData(#name8, sizeof #name8 - 1); \
        names[8] = realm::StringData(#name9, sizeof #name9 - 1); \
        names[9] = realm::StringData(#name10, sizeof #name10 - 1); \
        names[10] = realm::StringData(#name11, sizeof #name11 - 1); \
        names[11] = realm::StringData(#name12, sizeof #name12 - 1); \
        names[12] = realm::StringData(#name13, sizeof #name13 - 1); \
        names[13] = realm::StringData(#name14, sizeof #name14 - 1); \
        names[14] = realm::StringData(#name15, sizeof #name15 - 1); \
    } \
 \
    struct ConvenienceMethods { \
        void add(type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13, type14 name14, type15 name15) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->add((::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14, name15)); \
        } \
        void insert(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13, type14 name14, type15 name15) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->insert(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14, name15)); \
        } \
        void set(size_t _realm_i, type1 name1, type2 name2, type3 name3, type4 name4, type5 name5, type6 name6, type7 name7, type8 name8, type9 name9, type10 name10, type11 name11, type12 name12, type13 name13, type14 name14, type15 name15) \
        { \
            ::realm::BasicTable<Table##Spec>* const _realm_t = \
                static_cast< ::realm::BasicTable<Table##Spec>* >(this); \
            _realm_t->set(_realm_i, (::realm::util::tuple(), name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14, name15)); \
        } \
    }; \
}; \
typedef ::realm::BasicTable<Table##Spec> Table;


// clang-format on

#endif // REALM_TABLE_MACROS_HPP
