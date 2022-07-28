Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A35584530
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Jul 2022 19:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbiG1RpN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Jul 2022 13:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiG1RpM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Jul 2022 13:45:12 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EB56163;
        Thu, 28 Jul 2022 10:45:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A763B5C0110;
        Thu, 28 Jul 2022 13:45:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 28 Jul 2022 13:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1659030309; x=1659116709; bh=ko0vJyIFjn
        4EAY198gCAeE27IuxEQRjyTww5TFL/NT4=; b=R7QG7XH4fwgOrtyrKqoUTOFJ+C
        j2chYjOOw6Lw9uM3KX0EeAG2I166qGYv/i8m4gyRk2p9NXJ66DAPGNn804CtASmx
        5w6otsGT6xEsG5eli5fLENAbDtwwrvfFwHeQwF+Z1+4E11XnLojl6DrBX8ONMAAl
        GmeQVVAkeeCxI1cddLj18IOkcFg8UowuKa74a09AbnlzH0IDX7TRXA9BmNML8B2H
        Y1lB5Zw1uvbvfmLPnH6h/zzK9GpXVhGD0tEEL943x+EOtellMrThjFc/s1d20zVF
        qOJ5rijhUpm/+F2B1cMncRnsTOEttbKs9lxTy5GdNo/4aATw3srVqucdEfiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1659030309; x=1659116709; bh=ko0vJyIFjn4EAY198gCAeE27IuxE
        QRjyTww5TFL/NT4=; b=CJ0krKGOC/4CKE4sR1/cFm/Q0n9dx94xMh3q5VKPfmsD
        0QoE1g+uXykjR7Wla2IV/o6uVamSJwZZn+jzSeMgfnzLyAWobzURsL5lfSj5v7bZ
        MVghrqPlo6h8txtTy+dzZ/VQU9iCWU+im+WvbCIggWVFaaKTJwngHLdvBwNSu/Fa
        RuvTq1xcYSrkSDLaYxOPxWmh4r+aJ3J0YmO4tC0V4pPVF3EvwNRK3nZs/rh06h72
        Ay4FosqG1JRz6nwYjLDTZQIaSyaTwpd4GnwVm+CqZJjFcCsw6J1BKKyZjA1dXz8b
        vUEwax+b6T6d6xzjqTa9fTbXFB590za/Q76osEctKA==
X-ME-Sender: <xms:JcviYv99-7a50OLrwK5OL5-WnunPN0zZ-dEeOS1Dm0vyujPq6xQzKg>
    <xme:JcviYrvbUW3UBSt2rGszQNcLUczyYJTEgjhU7MhlK8r1G-5UrEu_Ghpf2HPqb7HJp
    8422TW1N3h8h1Q2WlQ>
X-ME-Received: <xmr:JcviYtDoCMmGRnX_iNy7JqiXPkI74hryLC8uvr3ZrTa9w8Mv3ynbtcyVPEhVTqgaUiNbhXt17EWFQofPmT_0jP321YjD4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdduhedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeehudevleekieetleevieeuhfduhedtiefgheekfe
    efgeelvdeuveeggfduueevfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:JcviYrdsmd7dPcI4Mo3-KeGNpFgmO59cTd7AJTrjWI_OoKbVMwOQ-Q>
    <xmx:JcviYkN498WNzSGsNZ-K_6m4HEzED60p2QcCLyg6S7XY0TwQDauYXA>
    <xmx:JcviYtkCFRnPEr6UsLFxDw816088OJixL9bNja73REe9ccGpsthQ6w>
    <xmx:JcviYtYqEvR6VY53Xf4V7dzfmsaWkGefop_RBON5Ji4DufMVD2QPBQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Jul 2022 13:45:08 -0400 (EDT)
Date:   Thu, 28 Jul 2022 10:45:07 -0700
From:   Boris Burkov <boris@bur.io>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: send: add support for fs-verity
Message-ID: <YuLLI1d83rCW4Tc5@zen>
References: <c2bcafee08a157d5638ad84fb9cfc692dce9bb86.1658965398.git.boris@bur.io>
 <20220728114332.GB13489@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728114332.GB13489@twin.jikos.cz>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 28, 2022 at 01:43:32PM +0200, David Sterba wrote:
> On Wed, Jul 27, 2022 at 04:46:22PM -0700, Boris Burkov wrote:
> > Preserve the fs-verity status of a btrfs file across send/recv.
> > 
> > There is no facility for installing the Merkle tree contents directly on
> > the receiving filesystem, so we package up the parameters used to enable
> > verity found in the verity descriptor. This gives the receive side
> > enough information to properly enable verity again. Note that this means
> > that receive will have to re-compute the whole Merkle tree, similar to
> > how compression worked before encoded_write.
> > 
> > Since the file becomes read-only after verity is enabled, it is
> > important that verity is added to the send stream after any file writes.
> > Therefore, when we process a verity item, merely note that it happened,
> > then actually create the command in the send stream during
> > 'finish_inode_if_needed'.
> > 
> > This also creates V3 of the send stream format, without any format
> > changes besides adding the new commands and attributes.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> > @@ -4886,6 +4889,80 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
> >  	return ret;
> >  }
> >  
> > +static int send_verity(struct send_ctx *sctx, struct fs_path *path,
> > +		       struct fsverity_descriptor *desc)
> > +{
> > +	int ret;
> > +
> > +	ret = begin_cmd(sctx, BTRFS_SEND_C_ENABLE_VERITY);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
> > +	TLV_PUT_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, desc->hash_algorithm);
> > +	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1 << desc->log_blocksize);
> 
> bitshifts should be done on unsigned types
> 
> 	1U << desc->log_blocksize
> 
> > +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
> > +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, desc->sig_size);
> > +
> > +	ret = send_cmd(sctx);
> > +
> > +tlv_put_failure:
> > +out:
> > +	return ret;
> > +}
> > +
> > +static int process_new_verity(struct send_ctx *sctx)
> > +{
> > +	int ret = 0;
> > +	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
> > +	struct inode *inode;
> > +	struct fsverity_descriptor *desc;
> > +	struct fs_path *p;
> > +
> > +	inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
> > +	if (IS_ERR(inode))
> > +		return PTR_ERR(inode);
> > +
> > +	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);
> > +	if (ret < 0)
> > +		goto iput;
> > +
> > +	if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
> > +		ret = -EMSGSIZE;
> > +		goto iput;
> > +	}
> > +	desc = kmalloc(ret, GFP_KERNEL);
> 
> I think that once there's a file with verity record there will be more
> so it would make sense to cache the allocated memory, which means to
> allocate the full size.
> 
> FS_VERITY_MAX_DESCRIPTOR_SIZE is 16K so this should be allocated by
> kvmalloc, like we have for other data during send.
> 
> > +	if (!desc) {
> > +		ret = -ENOMEM;
> > +		goto iput;
> > +	}
> > +
> > +	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, desc, ret);
> > +	if (ret < 0)
> > +		goto free_desc;
> > +
> > +	p = fs_path_alloc();
> > +	if (!p) {
> > +		ret = -ENOMEM;
> > +		goto free_desc;
> > +	}
> > +	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> > +	if (ret < 0)
> > +		goto free_path;
> > +
> > +	ret = send_verity(sctx, p, desc);
> > +	if (ret < 0)
> > +		goto free_path;
> > +
> > +free_path:
> > +	fs_path_free(p);
> > +free_desc:
> > +	kfree(desc);
> > +iput:
> > +	iput(inode);
> > +	return ret;
> > +}
> > +
> >  static inline u64 max_send_read_size(const struct send_ctx *sctx)
> >  {
> >  	return sctx->send_max_size - SZ_16K;
> > --- a/fs/btrfs/send.h
> > +++ b/fs/btrfs/send.h
> > @@ -92,8 +92,11 @@ enum btrfs_send_cmd {
> >  	BTRFS_SEND_C_ENCODED_WRITE	= 25,
> >  	BTRFS_SEND_C_MAX_V2		= 25,
> >  
> > +	/* Version 3 */
> > +	BTRFS_SEND_C_ENABLE_VERITY	= 26,
> 
> I find the name confusing, it sounds like enabling it for the whole
> filesystem, but it affects only one file.

Your point about fs-wide vs file specific makes sense,  but on the other
hand, that is the name of the ioctl and the cli command.

Would you prefer VERITY_ENABLE? or just VERITY? I am having trouble
thinking of a better name, but I also don't mind if you think of one
and rename it.

> 
> > +	BTRFS_SEND_C_MAX_V3		= 26,
> >  	/* End */
> > -	BTRFS_SEND_C_MAX		= 25,
> > +	BTRFS_SEND_C_MAX		= 26,
> >  };
> >  
> >  /* attributes in send stream */
> > @@ -160,8 +163,14 @@ enum {
> >  	BTRFS_SEND_A_ENCRYPTION		= 31,
> >  	BTRFS_SEND_A_MAX_V2		= 31,
> >  
> > -	/* End */
> > -	BTRFS_SEND_A_MAX		= 31,
> > +	/* Version 3 */
> > +	BTRFS_SEND_A_VERITY_ALGORITHM	= 32,
> > +	BTRFS_SEND_A_VERITY_BLOCK_SIZE	= 33,
> > +	BTRFS_SEND_A_VERITY_SALT_DATA	= 34,
> > +	BTRFS_SEND_A_VERITY_SIG_DATA	= 35,
> > +	BTRFS_SEND_A_MAX_V3		= 35,
> > +
> > +	__BTRFS_SEND_A_MAX		= 35,
> >  };
