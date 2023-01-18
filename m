Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19939672424
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Jan 2023 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjARQvi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 Jan 2023 11:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjARQvU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 Jan 2023 11:51:20 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C093B3D2;
        Wed, 18 Jan 2023 08:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674060676; x=1705596676;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=qBq10ouxVtiB3/iqe3X4Tyh7yKptJbnRSeCrgUrFlZY=;
  b=iczVRXE+dWv5PREAhaFJlkG2lmG7InBcio/kWku4WZxdScfXUtw2IQsW
   BX3GGbA7KNbEdh9aCg/V3WekCwaTpjqAOVYhevBgxkO6FaNY2b2IOUrmC
   qnT1ptifIPloEsRgO9WzLSLNSLG1yCbHXDcAiRTwbXj2f10PCTsDe8RkS
   bpAPbz6om3b2lFsilYU5kjygM5QKrtyZ3556GdfxIySVtWq7r3T+Wfa4J
   WqIfX1KkFFDXHsWBd+TkxzDQiYbz0RstMzQJVxGWD9wHjgm46bmUCi9my
   L3tfaO+z2/Gi/VIXZ01yNIpWmd+mTJcpX8/ulOkupmjxszii2UOUJqOhd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="323715982"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="323715982"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 08:51:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="767824583"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="767824583"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 18 Jan 2023 08:51:02 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIBeK-0000X9-2U;
        Wed, 18 Jan 2023 16:50:56 +0000
Date:   Thu, 19 Jan 2023 00:50:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 f3381a7baf5ccbd091eb2c4fd2afd84266fcef24
Message-ID: <63c82355.kCFspGLcQ170XMRT%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f3381a7baf5ccbd091eb2c4fd2afd84266fcef24  Add linux-next specific files for 20230118

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202301171511.4ZszviYP-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/mm/unevictable-lru.rst:186: WARNING: Title underline too short.
Error: failed to load BTF from vmlinux: No data available
drivers/scsi/qla2xxx/qla_mid.c:1094:51: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat=]
drivers/scsi/qla2xxx/qla_mid.c:1189:6: warning: no previous prototype for 'qla_trim_buf' [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_mid.c:1221:6: warning: no previous prototype for '__qla_adjust_buf' [-Wmissing-prototypes]
libbpf: failed to find '.BTF' ELF section in vmlinux

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/block/virtio_blk.c:721:9: sparse:    bad type *
drivers/block/virtio_blk.c:721:9: sparse:    unsigned int *
drivers/block/virtio_blk.c:721:9: sparse: sparse: incompatible types in comparison expression (different base types):
drivers/block/virtio_blk.c:721:9: sparse: sparse: no generic selection for 'restricted __le32 [addressable] virtio_cread_v'
drivers/block/virtio_blk.c:721:9: sparse: sparse: no generic selection for 'restricted __le32 virtio_cread_v'
drivers/nvmem/imx-ocotp.c:599:21: sparse: sparse: symbol 'imx_ocotp_layout' was not declared. Should it be static?
fs/verity/enable.c:29:2: warning: Null pointer passed as 1st argument to memory set function [clang-analyzer-unix.cstring.NullArg]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arc-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm64-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- csky-randconfig-s051-20230115
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- i386-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- ia64-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- ia64-buildonly-randconfig-r002-20230117
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- loongarch-randconfig-r035-20230116
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- mips-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- powerpc-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- s390-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- s390-randconfig-s052-20230115
|   |-- drivers-block-virtio_blk.c:sparse:bad-type
|   |-- drivers-block-virtio_blk.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-base-types):
|   |-- drivers-block-virtio_blk.c:sparse:sparse:no-generic-selection-for-restricted-__le32-addressable-virtio_cread_v
|   |-- drivers-block-virtio_blk.c:sparse:sparse:no-generic-selection-for-restricted-__le32-virtio_cread_v
|   |-- drivers-block-virtio_blk.c:sparse:unsigned-int
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- x86_64-allnoconfig
|   `-- Documentation-mm-unevictable-lru.rst:WARNING:Title-underline-too-short.
|-- x86_64-allyesconfig
clang_recent_errors
`-- i386-randconfig-c001
    `-- fs-verity-enable.c:warning:Null-pointer-passed-as-1st-argument-to-memory-set-function-clang-analyzer-unix.cstring.NullArg

elapsed time: 728m

configs tested: 63
configs skipped: 2

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                           allnoconfig
i386                                defconfig
arc                                 defconfig
m68k                             allyesconfig
alpha                               defconfig
m68k                             allmodconfig
arm                                 defconfig
s390                             allmodconfig
arc                              allyesconfig
x86_64                              defconfig
alpha                            allyesconfig
s390                                defconfig
x86_64                            allnoconfig
x86_64                               rhel-8.3
s390                             allyesconfig
arm                              allyesconfig
arm64                            allyesconfig
x86_64               randconfig-a011-20230116
x86_64               randconfig-a013-20230116
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
sh                               allmodconfig
x86_64                           rhel-8.3-kvm
x86_64               randconfig-a012-20230116
x86_64               randconfig-a015-20230116
x86_64                           rhel-8.3-bpf
x86_64                           allyesconfig
powerpc                          allmodconfig
x86_64                          rhel-8.3-func
i386                             allyesconfig
ia64                             allmodconfig
arc                  randconfig-r043-20230118
x86_64               randconfig-a014-20230116
mips                             allyesconfig
x86_64               randconfig-a016-20230116
i386                          randconfig-a014
riscv                randconfig-r042-20230118
i386                          randconfig-a012
s390                 randconfig-r044-20230118
i386                          randconfig-a016
x86_64               randconfig-k001-20230116

clang tested configs:
x86_64                          rhel-8.3-rust
hexagon              randconfig-r045-20230118
x86_64               randconfig-a001-20230116
i386                 randconfig-a002-20230116
i386                 randconfig-a004-20230116
x86_64               randconfig-a002-20230116
i386                          randconfig-a013
x86_64               randconfig-a004-20230116
i386                          randconfig-a015
hexagon              randconfig-r041-20230118
x86_64               randconfig-a005-20230116
x86_64               randconfig-a006-20230116
arm                  randconfig-r046-20230118
x86_64               randconfig-a003-20230116
i386                          randconfig-a011
i386                 randconfig-a003-20230116
i386                 randconfig-a006-20230116
i386                 randconfig-a005-20230116
i386                 randconfig-a001-20230116

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
