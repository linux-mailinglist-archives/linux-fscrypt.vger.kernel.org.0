Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB83B5A6B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Jun 2021 10:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhF1I0k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Jun 2021 04:26:40 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30474 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232308AbhF1I0k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Jun 2021 04:26:40 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15S8HOKF004776;
        Mon, 28 Jun 2021 08:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=wBJc68J6FfqbkSDvgft75jgJulylQJrx8DBqitXAQWE=;
 b=tol1zIFNU1vVGTgSpKxPcYvMzF6rUNN7y3D9MMuCpWtZvACMJBwVTQsIhbWfpNwDN+mn
 A5U75rQUIhQqwtJBKzPIIt3hOfDLUlhHS6WsNCgOfeeTB+wyVbiQ1aU9fEPEgqwXMsWd
 A4/Hyl/+F1xnIdKXTMkYzWkUKNDfkf4CLIutoF/Da3W0SCpBaCctukx6PCEgNkHGud+J
 gBGHZB8ZxAxS3paVzNGhmjX9gCd0AiJDrRAGx0xCFEeRcm0m8WBDnLRUIob55/7I0L1Z
 JJs+bdFLgiKUkgVMyIUNhYIHuU/L52FhAJOpLBWuRix2zXqVluJ05AV//tBzPrhPOce2 gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39esfks1ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 08:24:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15S8LZCL156286;
        Mon, 28 Jun 2021 08:24:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 39dsbv1ak2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 08:24:02 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15S8O1a8162352;
        Mon, 28 Jun 2021 08:24:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 39dsbv1ahx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Jun 2021 08:24:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15S8Nxej005881;
        Mon, 28 Jun 2021 08:24:00 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Jun 2021 01:23:59 -0700
Date:   Mon, 28 Jun 2021 11:23:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org
Subject: Re: [PATCH v5 2/3] btrfs: initial fsverity support
Message-ID: <202106260148.y7YIYV3M-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <459e0acf996441628bc465bbe64218d7fea132c4.1624573983.git.boris@bur.io>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: UKhpj-DgsE8mWxEMVKUfbaT3ppKaJQwh
X-Proofpoint-GUID: UKhpj-DgsE8mWxEMVKUfbaT3ppKaJQwh
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Boris,

url:    https://github.com/0day-ci/linux/commits/Boris-Burkov/btrfs-support-fsverity/20210625-064209
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: parisc-randconfig-m031-20210625 (attached as .config)
compiler: hppa-linux-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/btrfs/verity.c:268 write_key_bytes() error: uninitialized symbol 'ret'.
fs/btrfs/verity.c:745 btrfs_write_merkle_tree_block() warn: should '1 << log_blocksize' be a 64 bit type?

Old smatch warnings:
fs/btrfs/verity.c:552 btrfs_begin_enable_verity() error: uninitialized symbol 'trans'.

vim +/ret +268 fs/btrfs/verity.c

24749321fc3abc Boris Burkov 2021-06-24  209  static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
24749321fc3abc Boris Burkov 2021-06-24  210  			   const char *src, u64 len)
24749321fc3abc Boris Burkov 2021-06-24  211  {
24749321fc3abc Boris Burkov 2021-06-24  212  	struct btrfs_trans_handle *trans;
24749321fc3abc Boris Burkov 2021-06-24  213  	struct btrfs_path *path;
24749321fc3abc Boris Burkov 2021-06-24  214  	struct btrfs_root *root = inode->root;
24749321fc3abc Boris Burkov 2021-06-24  215  	struct extent_buffer *leaf;
24749321fc3abc Boris Burkov 2021-06-24  216  	struct btrfs_key key;
24749321fc3abc Boris Burkov 2021-06-24  217  	u64 copied = 0;
24749321fc3abc Boris Burkov 2021-06-24  218  	unsigned long copy_bytes;
24749321fc3abc Boris Burkov 2021-06-24  219  	unsigned long src_offset = 0;
24749321fc3abc Boris Burkov 2021-06-24  220  	void *data;
24749321fc3abc Boris Burkov 2021-06-24  221  	int ret;
24749321fc3abc Boris Burkov 2021-06-24  222  
24749321fc3abc Boris Burkov 2021-06-24  223  	path = btrfs_alloc_path();
24749321fc3abc Boris Burkov 2021-06-24  224  	if (!path)
24749321fc3abc Boris Burkov 2021-06-24  225  		return -ENOMEM;
24749321fc3abc Boris Burkov 2021-06-24  226  
24749321fc3abc Boris Burkov 2021-06-24  227  	while (len > 0) {

Can we write zero bytes?  My test system has linux-next so I don't know.
I don't think the kbuild bot uses the cross function DB so it doesn't
know either.

24749321fc3abc Boris Burkov 2021-06-24  228  		/*
24749321fc3abc Boris Burkov 2021-06-24  229  		 * 1 for the new item being inserted
24749321fc3abc Boris Burkov 2021-06-24  230  		 */
24749321fc3abc Boris Burkov 2021-06-24  231  		trans = btrfs_start_transaction(root, 1);
24749321fc3abc Boris Burkov 2021-06-24  232  		if (IS_ERR(trans)) {
24749321fc3abc Boris Burkov 2021-06-24  233  			ret = PTR_ERR(trans);
24749321fc3abc Boris Burkov 2021-06-24  234  			break;
24749321fc3abc Boris Burkov 2021-06-24  235  		}
24749321fc3abc Boris Burkov 2021-06-24  236  
24749321fc3abc Boris Burkov 2021-06-24  237  		key.objectid = btrfs_ino(inode);
24749321fc3abc Boris Burkov 2021-06-24  238  		key.type = key_type;
24749321fc3abc Boris Burkov 2021-06-24  239  		key.offset = offset;
24749321fc3abc Boris Burkov 2021-06-24  240  
24749321fc3abc Boris Burkov 2021-06-24  241  		/*
24749321fc3abc Boris Burkov 2021-06-24  242  		 * Insert 2K at a time mostly to be friendly for smaller
24749321fc3abc Boris Burkov 2021-06-24  243  		 * leaf size filesystems
24749321fc3abc Boris Burkov 2021-06-24  244  		 */
24749321fc3abc Boris Burkov 2021-06-24  245  		copy_bytes = min_t(u64, len, 2048);
24749321fc3abc Boris Burkov 2021-06-24  246  
24749321fc3abc Boris Burkov 2021-06-24  247  		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
24749321fc3abc Boris Burkov 2021-06-24  248  		if (ret) {
24749321fc3abc Boris Burkov 2021-06-24  249  			btrfs_end_transaction(trans);
24749321fc3abc Boris Burkov 2021-06-24  250  			break;
24749321fc3abc Boris Burkov 2021-06-24  251  		}
24749321fc3abc Boris Burkov 2021-06-24  252  
24749321fc3abc Boris Burkov 2021-06-24  253  		leaf = path->nodes[0];
24749321fc3abc Boris Burkov 2021-06-24  254  
24749321fc3abc Boris Burkov 2021-06-24  255  		data = btrfs_item_ptr(leaf, path->slots[0], void);
24749321fc3abc Boris Burkov 2021-06-24  256  		write_extent_buffer(leaf, src + src_offset,
24749321fc3abc Boris Burkov 2021-06-24  257  				    (unsigned long)data, copy_bytes);
24749321fc3abc Boris Burkov 2021-06-24  258  		offset += copy_bytes;
24749321fc3abc Boris Burkov 2021-06-24  259  		src_offset += copy_bytes;
24749321fc3abc Boris Burkov 2021-06-24  260  		len -= copy_bytes;
24749321fc3abc Boris Burkov 2021-06-24  261  		copied += copy_bytes;
24749321fc3abc Boris Burkov 2021-06-24  262  
24749321fc3abc Boris Burkov 2021-06-24  263  		btrfs_release_path(path);
24749321fc3abc Boris Burkov 2021-06-24  264  		btrfs_end_transaction(trans);
24749321fc3abc Boris Burkov 2021-06-24  265  	}
24749321fc3abc Boris Burkov 2021-06-24  266  
24749321fc3abc Boris Burkov 2021-06-24  267  	btrfs_free_path(path);
24749321fc3abc Boris Burkov 2021-06-24 @268  	return ret;
24749321fc3abc Boris Burkov 2021-06-24  269  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

