Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A29F3B8942
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Jun 2021 21:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhF3Top (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Jun 2021 15:44:45 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60639 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229700AbhF3Top (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Jun 2021 15:44:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E32C532002B6;
        Wed, 30 Jun 2021 15:42:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 30 Jun 2021 15:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=pSCZ+MvUdyoXL2waiMJX8caRYRd
        SqpyDZkUtStv7C9g=; b=RXonf+BseE6ZwvgreE7O0Tsqi9cxU49U8jjBjAIteUo
        rT0cOnO7FQms9Zhgpmx8QIDitEGvoPyg8vsdJY1hgN6kqvDy/yjmwBL8uvC+WczX
        xC+wISSUpYkTXxmS5VLxGfBZHKuDrTJnpbSWu+JQvIxSNr5AxjQ5m6Zdsvoc61gi
        HhSkYdB/QtLLD+FtlA5rXTw9y+x8f/f08tIV8Ipo9+pfeWaY2cZCnKFx/97Huo3R
        IMaQnQRhbMbOVuDZV+8Q/5ozv9kSrNVvmI49N7biwnONEwqI6ipjya9YzGxlkvHq
        J+iZeJsa5kL2kkraVWoGPft7I/HNXF9/A/D5wdbxhaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pSCZ+M
        vUdyoXL2waiMJX8caRYRdSqpyDZkUtStv7C9g=; b=O8bm88KWOhsKoA1ycTlql6
        AKJGl9w61r8QsPjId7gH3bAIanI3+4HdH9Gjh4dYeowA2sOBwutKDlYixfufmoyL
        g1Sn5EpCapJzdQmoDCdbqqPZPqEW6zfsVWZI2se+3RTxNG9/fDftAhS/atUM9yUi
        b9KdI5OwsVk+tohHCurwHA7yuNlDbLz/LlA32LnkGLfOfAbjsFvcYI1+AWzo0Xvd
        xxyXloNuKOlSIqegRaPWmlG5SkmcQDxvXQV/cBJ68vQpQk1zmXeEAiMFpogXcPW9
        hjA35ukU3qMzrxh5Lgya48Qz4SX841mH/idW3OrrP5lt3x2fT6k1bd5BIlRjR9rw
        ==
X-ME-Sender: <xms:FcncYFB0GZPE4NC7TyXeFvocAWVlTB3Hzw_oDB-zBFJP3tfzenNj8g>
    <xme:FcncYDiCDGJfKpz9msQIResshaqTV2auX30oQP3ef8wsYkIKMMBoiS5LqjHQIKsk3
    4dSSAWiDBcBFukqj3M>
X-ME-Received: <xmr:FcncYAkaUo-6S0ISlgwHkc2x9HD1Cu0byhLqasnMNcEE7wgJDgaEOt0qCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepje
    etkeekkeevieefudduudeutddthfefieehveehjeekveehueehudetlefgkeeknecuffho
    mhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgpddtuddrohhrghenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhs
    segsuhhrrdhioh
X-ME-Proxy: <xmx:FcncYPyXiNzW8rC9gWknHw4muMsJy10pby7Hq_LZGsnUCbKr9OPr4Q>
    <xmx:FcncYKTiSH9CINBLrP6dgRrzLhomSiMN0AENQdAvvcHAI0WMM7DzBg>
    <xmx:FcncYCZ0vlX7QsbfyDBLcFoABbYbmRDzAKLnI2L1r2rYKLivi9Su_g>
    <xmx:FsncYHJIWYpXMBsUaR7jgKMPa7UKrW5Fa3Uw2_WGBBfEPCXH2KrIFg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Jun 2021 15:42:13 -0400 (EDT)
Date:   Wed, 30 Jun 2021 12:42:11 -0700
From:   Boris Burkov <boris@bur.io>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com, lkp@intel.com,
        kbuild-all@lists.01.org
Subject: Re: [PATCH v5 2/3] btrfs: initial fsverity support
Message-ID: <YNzJBAOomwEiNgDn@zen>
References: <459e0acf996441628bc465bbe64218d7fea132c4.1624573983.git.boris@bur.io>
 <202106260148.y7YIYV3M-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202106260148.y7YIYV3M-lkp@intel.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jun 28, 2021 at 11:23:51AM +0300, Dan Carpenter wrote:
> Hi Boris,
> 
> url:    https://github.com/0day-ci/linux/commits/Boris-Burkov/btrfs-support-fsverity/20210625-064209
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> config: parisc-randconfig-m031-20210625 (attached as .config)
> compiler: hppa-linux-gcc (GCC) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> New smatch warnings:
> fs/btrfs/verity.c:268 write_key_bytes() error: uninitialized symbol 'ret'.
> fs/btrfs/verity.c:745 btrfs_write_merkle_tree_block() warn: should '1 << log_blocksize' be a 64 bit type?

good catch :)

> 
> Old smatch warnings:
> fs/btrfs/verity.c:552 btrfs_begin_enable_verity() error: uninitialized symbol 'trans'.

This was a screw up from re-arranging the patches, will clean up.

> 
> vim +/ret +268 fs/btrfs/verity.c
> 
> 24749321fc3abc Boris Burkov 2021-06-24  209  static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> 24749321fc3abc Boris Burkov 2021-06-24  210  			   const char *src, u64 len)
> 24749321fc3abc Boris Burkov 2021-06-24  211  {
> 24749321fc3abc Boris Burkov 2021-06-24  212  	struct btrfs_trans_handle *trans;
> 24749321fc3abc Boris Burkov 2021-06-24  213  	struct btrfs_path *path;
> 24749321fc3abc Boris Burkov 2021-06-24  214  	struct btrfs_root *root = inode->root;
> 24749321fc3abc Boris Burkov 2021-06-24  215  	struct extent_buffer *leaf;
> 24749321fc3abc Boris Burkov 2021-06-24  216  	struct btrfs_key key;
> 24749321fc3abc Boris Burkov 2021-06-24  217  	u64 copied = 0;
> 24749321fc3abc Boris Burkov 2021-06-24  218  	unsigned long copy_bytes;
> 24749321fc3abc Boris Burkov 2021-06-24  219  	unsigned long src_offset = 0;
> 24749321fc3abc Boris Burkov 2021-06-24  220  	void *data;
> 24749321fc3abc Boris Burkov 2021-06-24  221  	int ret;
> 24749321fc3abc Boris Burkov 2021-06-24  222  
> 24749321fc3abc Boris Burkov 2021-06-24  223  	path = btrfs_alloc_path();
> 24749321fc3abc Boris Burkov 2021-06-24  224  	if (!path)
> 24749321fc3abc Boris Burkov 2021-06-24  225  		return -ENOMEM;
> 24749321fc3abc Boris Burkov 2021-06-24  226  
> 24749321fc3abc Boris Burkov 2021-06-24  227  	while (len > 0) {
> 
> Can we write zero bytes?  My test system has linux-next so I don't know.
> I don't think the kbuild bot uses the cross function DB so it doesn't
> know either.

Considering the three callsites and then the callsite of
end_enable_verity in fs/verity/enable.c, I don't think it's possible to
call write_key_bytes with len==0, but it doesn't hurt to fix it anyway,
just in case. It makes write_key_bytes more correct as documented, at
least.

> 
> 24749321fc3abc Boris Burkov 2021-06-24  228  		/*
> 24749321fc3abc Boris Burkov 2021-06-24  229  		 * 1 for the new item being inserted
> 24749321fc3abc Boris Burkov 2021-06-24  230  		 */
> 24749321fc3abc Boris Burkov 2021-06-24  231  		trans = btrfs_start_transaction(root, 1);
> 24749321fc3abc Boris Burkov 2021-06-24  232  		if (IS_ERR(trans)) {
> 24749321fc3abc Boris Burkov 2021-06-24  233  			ret = PTR_ERR(trans);
> 24749321fc3abc Boris Burkov 2021-06-24  234  			break;
> 24749321fc3abc Boris Burkov 2021-06-24  235  		}
> 24749321fc3abc Boris Burkov 2021-06-24  236  
> 24749321fc3abc Boris Burkov 2021-06-24  237  		key.objectid = btrfs_ino(inode);
> 24749321fc3abc Boris Burkov 2021-06-24  238  		key.type = key_type;
> 24749321fc3abc Boris Burkov 2021-06-24  239  		key.offset = offset;
> 24749321fc3abc Boris Burkov 2021-06-24  240  
> 24749321fc3abc Boris Burkov 2021-06-24  241  		/*
> 24749321fc3abc Boris Burkov 2021-06-24  242  		 * Insert 2K at a time mostly to be friendly for smaller
> 24749321fc3abc Boris Burkov 2021-06-24  243  		 * leaf size filesystems
> 24749321fc3abc Boris Burkov 2021-06-24  244  		 */
> 24749321fc3abc Boris Burkov 2021-06-24  245  		copy_bytes = min_t(u64, len, 2048);
> 24749321fc3abc Boris Burkov 2021-06-24  246  
> 24749321fc3abc Boris Burkov 2021-06-24  247  		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
> 24749321fc3abc Boris Burkov 2021-06-24  248  		if (ret) {
> 24749321fc3abc Boris Burkov 2021-06-24  249  			btrfs_end_transaction(trans);
> 24749321fc3abc Boris Burkov 2021-06-24  250  			break;
> 24749321fc3abc Boris Burkov 2021-06-24  251  		}
> 24749321fc3abc Boris Burkov 2021-06-24  252  
> 24749321fc3abc Boris Burkov 2021-06-24  253  		leaf = path->nodes[0];
> 24749321fc3abc Boris Burkov 2021-06-24  254  
> 24749321fc3abc Boris Burkov 2021-06-24  255  		data = btrfs_item_ptr(leaf, path->slots[0], void);
> 24749321fc3abc Boris Burkov 2021-06-24  256  		write_extent_buffer(leaf, src + src_offset,
> 24749321fc3abc Boris Burkov 2021-06-24  257  				    (unsigned long)data, copy_bytes);
> 24749321fc3abc Boris Burkov 2021-06-24  258  		offset += copy_bytes;
> 24749321fc3abc Boris Burkov 2021-06-24  259  		src_offset += copy_bytes;
> 24749321fc3abc Boris Burkov 2021-06-24  260  		len -= copy_bytes;
> 24749321fc3abc Boris Burkov 2021-06-24  261  		copied += copy_bytes;
> 24749321fc3abc Boris Burkov 2021-06-24  262  
> 24749321fc3abc Boris Burkov 2021-06-24  263  		btrfs_release_path(path);
> 24749321fc3abc Boris Burkov 2021-06-24  264  		btrfs_end_transaction(trans);
> 24749321fc3abc Boris Burkov 2021-06-24  265  	}
> 24749321fc3abc Boris Burkov 2021-06-24  266  
> 24749321fc3abc Boris Burkov 2021-06-24  267  	btrfs_free_path(path);
> 24749321fc3abc Boris Burkov 2021-06-24 @268  	return ret;
> 24749321fc3abc Boris Burkov 2021-06-24  269  }
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
