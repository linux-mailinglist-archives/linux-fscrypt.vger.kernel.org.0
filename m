Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E1E7BC394
	for <lists+linux-fscrypt@lfdr.de>; Sat,  7 Oct 2023 03:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbjJGBUu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 Oct 2023 21:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjJGBUs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 Oct 2023 21:20:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DBCB6;
        Fri,  6 Oct 2023 18:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696641646; x=1728177646;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=+1oX3XmrPhIs7No+iF1tjIPtK+bWfLRDJG2REwgaIHw=;
  b=ZHSNO9buqMrMb5hLjhPlWEyDPcu8fIX1SeucAPp2c/JHpCpKxM4n6pTq
   zBX+LqQJmI7J0ROd8Reg0ocu21jVx2nSGATxtCy7qE2jhnOb6JqXCHsme
   VTnWe6rzEqygA9ttZQs4WXrGTuNGobulxrRDQ+vpDp0ubqVWhVmkF8RQ2
   4BhxereHGlqkQ0GQVETgkcPyrAwilyxarz+99rI3r1WIkzbhvsIL86Mt7
   S+bTKD6P3iTcAAD8XH+njrgPJuApBgUmzBA69/ZAiiqoFCeth9XfXMjWe
   MQI0eAUfcyxb+RwlOK5xauo5uvWGySQlvqXe5jyuhTqeM02YGIxQoHTGp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="374206670"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="374206670"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 18:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="999555513"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="999555513"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 18:20:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 18:20:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 18:20:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 18:20:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4TPCWv2d+FSnDAJVpBrZ1PanlPUF4ngdcez0ftomWcFtlJ1nPUfAIIUNinEa/9YdekoqXuhvUI/xt+LUyu1Qr2GT5jMGW6AHjbjxSp9uWzWjLY82KsYqNRt6tU7vhKpyZmP9ni0km1jD7crw41uVdvzT5znMUBevsCGSfcPfIASAzbYube0ixmT3vFCo49snSoxwzfa9SiXF21OUwQt1Pf8sIpNesPZl4zuV4JRrv0xsgYBkRfqm3CyhXeDbctJ/5gQyQORqv425GE/WDW8KDJ2BvCGFzOtcd5kU44DzxY+RxUQ3xBF19irwBmRlkyr9Q+6QqeuLAdTBAoblQpK8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jy2FqbYiJ0yKu54RsK17Hw03zcn+SR8GNFrl2PbKwpg=;
 b=CYYt1ANuxwPRDlVlFtr7WsNJlpbrAIIcsVRBm5CXmCUM8HEEaHyGxekVsD7Qb5AWTeMOQhU0nATv0yHswlCCXDvo7q+jCuHR5VuYQpoMOVDJue4mnvZotYyGE0CkOyId8FtcHsnAVBZ/hFwhJX92gLoh4T7VCbs9hXFZkJW+eSAcbpE2TR3w9Q0EfRsJ+zpLVU9YDnQYqzCjkcTECALqPW9Y7Iqj0aKp3OWYJDJGZIEzkPT6F4pCsuWaqddmM80bk7Z5/PxgxIPraoFquXMwlaarUV4t70FZ/cvBw/C8TNaKi9pdpryiYgWnNVY5f3toZb4mhJQ5VQpDPTf6Aohn7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by CH0PR11MB5235.namprd11.prod.outlook.com (2603:10b6:610:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.34; Sat, 7 Oct
 2023 01:20:41 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::d35:d16b:4ee3:77e5]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::d35:d16b:4ee3:77e5%7]) with mapi id 15.20.6838.030; Sat, 7 Oct 2023
 01:20:41 +0000
Date:   Sat, 7 Oct 2023 09:15:44 +0800
From:   kernel test robot <yujie.liu@intel.com>
To:     Josef Bacik <josef@toxicpanda.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-team@fb.com>, <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <ngompa13@gmail.com>
CC:     <oe-kbuild-all@lists.linux.dev>,
        Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 13/35] btrfs: adapt readdir for encrypted and nokey names
Message-ID: <202310050449.35KiNskt-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e405fffae735ea6a250c58bd7ad199281f111f9a.1695750478.git.josef@toxicpanda.com>
X-ClientProxiedBy: SI1PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::14) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|CH0PR11MB5235:EE_
X-MS-Office365-Filtering-Correlation-Id: 179b9d2b-98e8-4897-fac2-08dbc6d39f46
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4s4pkynxHwNe7ENUktoB9yMC5ZcFyPuPLDTeAGYh/lCYii5OATyvEEOtRD6W7x3hPRVQZAK2PW8kw9uF+W0OsjFe39fzjMtayOja3eOC1PMcuOvVcDrw6FJSlVstoq8zgS90CTX1VjRWgb1mCe8m/eAl7TDRCeFum6BNzZspjDAc3k2Dpa0y+NFyKqUOXQvmK6nzPkEZoWorMpDv+xYOqfItBGJrSYbo66l8okPdri1QJzzXJpEbV/Yz4ijitEDJvz3+WOuLjhO3iWQKrplD+kWEaeZ8QgxOHtx9oFJxwCeZmdBbxY+566wqoJt2YV54cYi/T1W2cLH/3kvejBXIM7ZTa610mLthMCIM1SIiNej5Ocbdim94dngSSRfIGNzugcvwTeOIqVWPmlQ47VwRiMjwWNG6IrTzVuaqfBSWhl6vErkywRhicHxNGAPp/ItH1UQI9J4V237qMaxoEqL8VPIFNAefsVxEbPKaU9fq2Nsiljb8o/u2SkHXiHzN3YNrBOFvAyKjUBWmlKIJnBRPHyO6EhqwyV2aDjdSNta4eV1omSvq0Vptc5eNTEYylfCNheboLudcjv/6rtgb3FyvGIQOGl3GOni6EQ8f/D0B8/bloJvKdPBZkRKxqBfBcOz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(346002)(136003)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(38100700002)(66476007)(316002)(1076003)(6506007)(41300700001)(6512007)(2906002)(36756003)(66556008)(83380400001)(5660300002)(26005)(4326008)(8936002)(8676002)(2616005)(54906003)(82960400001)(966005)(6486002)(66946007)(86362001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uX0bHvuAfEbTZAdYnCstRsdNycOBmHpX/ITNSkwq0MALwL6n1Op2ezrum9JZ?=
 =?us-ascii?Q?qvE/exd4Heb4dfvHF+qe0qcU8JZ/fvKsKU3o7rwd/vTGERIQPo2ijD0dQwGE?=
 =?us-ascii?Q?s/9KUTnGL+APwJDyXkR5ZiRg4cPBc2jDV0UhCy13d+yl10YtxLmmonFJvVO+?=
 =?us-ascii?Q?ABsXTHyczZSqmBlAZyeDEAiSXqOxbIbi/4zdY7qpQL7A2N2OIQeKIlHwhojB?=
 =?us-ascii?Q?JCGVruhx5kmKK4ZxF/oSE2OsYVwrMueHbvay3IhwuVwDXHAPo5xQAJoxZ2fJ?=
 =?us-ascii?Q?pA/gJmxSg7LoisDasDuHDwi2iDNesCeHyjKUOXt+r1xfo/JFkryk2L9A7Sk7?=
 =?us-ascii?Q?ddME29Kc2zxcBB4hO+xb3RF9ha450T1EDWmD/R5MjZie6g7kSHeyo1Z7tnlU?=
 =?us-ascii?Q?2onXVUgpWN89H5u95RiBrVsWJAlT5O/OYEP8zWIf36+wRsMGJtTfSTwGueN9?=
 =?us-ascii?Q?6+uVVO0qUtVYuNoc6x4wCBHWkpjNLaw+1+a9wjzGkcNcExyHf8Uxpph0q7Xj?=
 =?us-ascii?Q?0DuU+dPMWv0DyatIrcFMb8Wv2Q+VgfuwG7ZAsHa8eoILHlVsSWbCmswyn4uQ?=
 =?us-ascii?Q?BhsoFyP1v4GOT8f567+rwVFNGIuS/GdjbyHIB6SY2jNSs5VdJZr3/pp72SJj?=
 =?us-ascii?Q?r8U49baOWsy/TvnDKbfPkskpNgUdMUPZWU7EiJa6naxC9Jj9s4scJxei7vh0?=
 =?us-ascii?Q?UnNWbRBJ0m6h691G+AIYEJwsfcGUX+J3qypgk4WFMANcGRzjhp/mkPQScCn0?=
 =?us-ascii?Q?hf/cJwFqhlMd4v42JcWYdekest55mZ9yAlmK+xkDlqmcbNp8bfVk25ovRL/W?=
 =?us-ascii?Q?UCe6JQzjuPpDXDMab7rPMC8h7/HCO5JisBQv4TOiaGFP+cVJLJbeF6FhaHDi?=
 =?us-ascii?Q?becwcsKxlk6r1L9RBJJRv3I7WHmfxO5nNwxKOjyzs0ahIvVnxjuXw0OjFuYL?=
 =?us-ascii?Q?3zoSms9sOm3iXlusOgLVQlGttvMu0/0ilIXPveM2IQmbUDjhAXTaNJxubQ8T?=
 =?us-ascii?Q?4K6RuQGZjLtMU0oRucd9J8hImNQ9t6apikVeHLCkrTGrRwa68yDvOB3of8NI?=
 =?us-ascii?Q?n/ekb1rML5Rr1KaYkJl+1MTYPpybLya6I4E06/Qd0mSoIlOETy4mJ1JU/WZ7?=
 =?us-ascii?Q?YwnL3V5CDcL4Xf/XCpLBvUmAc4mUho9e68IcAihiIKZMwGUMFHD6dEaLmHIN?=
 =?us-ascii?Q?gGnw+sb58wVETYk1WSdsfD/HXXLsWuMKnTnY4cryup2l4TV2CtgnCjp1I8fU?=
 =?us-ascii?Q?Sd80ZoPUwHHlrXeD34Dy3zk0s/IOD3A7ns1MTXSBkGnA0JQk1wDROW73W78J?=
 =?us-ascii?Q?S49DMHUCpkFDpyYatTA3GtTq8cDxHF1QKTKN/rN/ud6ZmnqwXP/KnDPbLzpX?=
 =?us-ascii?Q?+H6cscpAyDWNJE5kblIL7cp4bkKoteWO896ZHtihJdiOh18pXfy62vdMaQ8L?=
 =?us-ascii?Q?RButZwUcwK/dyMLM/e/uq0RMfBdnCxf0YrzZ4A0oLeG6TI8RyBaINQTLmfe3?=
 =?us-ascii?Q?LLiyqnI2G1L++Kvug0D/BZEv+pkQynRHJ4+LPhl5lpKFED2K/hdZ2uTNb+Yu?=
 =?us-ascii?Q?W3oRGUNyZbRayzgJF4i2SCdl/WEgDBtUjPhJrpr+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 179b9d2b-98e8-4897-fac2-08dbc6d39f46
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2023 01:20:41.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMukxZGa26A0otbcKBIWv/HlqVciw71SeZFva7DB9uE88BM5BmkgrO41LcjGXP1SN9uc+E4eGlNETo1whImI1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5235
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Josef,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kdave/for-next]
[cannot apply to axboe-block/for-next linus/master v6.6-rc4 next-20231004]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Josef-Bacik/fscrypt-rename-fscrypt_info-fscrypt_inode_info/20230927-020531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/e405fffae735ea6a250c58bd7ad199281f111f9a.1695750478.git.josef%40toxicpanda.com
patch subject: [PATCH 13/35] btrfs: adapt readdir for encrypted and nokey names
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202310050449.35KiNskt-lkp@intel.com/

includecheck warnings: (new ones prefixed by >>)
>> fs/btrfs/fscrypt.c: ioctl.h is included more than once.

vim +8 fs/btrfs/fscrypt.c

     2	
     3	#include <linux/iversion.h>
     4	#include "ctree.h"
     5	#include "accessors.h"
     6	#include "btrfs_inode.h"
     7	#include "disk-io.h"
   > 8	#include "ioctl.h"
     9	#include "fs.h"
    10	#include "fscrypt.h"
  > 11	#include "ioctl.h"
    12	#include "messages.h"
    13	#include "root-tree.h"
    14	#include "transaction.h"
    15	#include "xattr.h"
    16	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

