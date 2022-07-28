Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC24583DFF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Jul 2022 13:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiG1Lsf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Jul 2022 07:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbiG1Lsd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Jul 2022 07:48:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306DD67CB8;
        Thu, 28 Jul 2022 04:48:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DF40720C2C;
        Thu, 28 Jul 2022 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659008910;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pwOjgLy7u0hEroDJaHgOe3inTn7T2kSY5l2OGj6m4pk=;
        b=rOlaBREjUrqvqF+WczLC8eN/lEGr6Lru1wI9cIoeRbZ4Kcpyw2Jf/HP+gW9R1q/qjsianP
        nWc/h6RSAX2y3i1xHMSE4IjpX+wGF0oyzSpIgOvLNrJOYtAMilutpjMoFBJA7MLJsRdzzE
        lLXOT7zsqv9ZWxbTPc5Br127yAbewrg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659008910;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pwOjgLy7u0hEroDJaHgOe3inTn7T2kSY5l2OGj6m4pk=;
        b=IggoF+yF3BmU5trzof8cUYyuANVLfY0FrKBtSZb+d6R918gPksWGPbA5ch9DNmoUonvOhP
        LLUmrQ2dws/DnXBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E9BE13A7E;
        Thu, 28 Jul 2022 11:48:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bYW9JY534mKyFQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 28 Jul 2022 11:48:30 +0000
Date:   Thu, 28 Jul 2022 13:43:32 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] btrfs: send: add support for fs-verity
Message-ID: <20220728114332.GB13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <c2bcafee08a157d5638ad84fb9cfc692dce9bb86.1658965398.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2bcafee08a157d5638ad84fb9cfc692dce9bb86.1658965398.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 27, 2022 at 04:46:22PM -0700, Boris Burkov wrote:
> Preserve the fs-verity status of a btrfs file across send/recv.
> 
> There is no facility for installing the Merkle tree contents directly on
> the receiving filesystem, so we package up the parameters used to enable
> verity found in the verity descriptor. This gives the receive side
> enough information to properly enable verity again. Note that this means
> that receive will have to re-compute the whole Merkle tree, similar to
> how compression worked before encoded_write.
> 
> Since the file becomes read-only after verity is enabled, it is
> important that verity is added to the send stream after any file writes.
> Therefore, when we process a verity item, merely note that it happened,
> then actually create the command in the send stream during
> 'finish_inode_if_needed'.
> 
> This also creates V3 of the send stream format, without any format
> changes besides adding the new commands and attributes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
> @@ -4886,6 +4889,80 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
>  	return ret;
>  }
>  
> +static int send_verity(struct send_ctx *sctx, struct fs_path *path,
> +		       struct fsverity_descriptor *desc)
> +{
> +	int ret;
> +
> +	ret = begin_cmd(sctx, BTRFS_SEND_C_ENABLE_VERITY);
> +	if (ret < 0)
> +		goto out;
> +
> +	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
> +	TLV_PUT_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, desc->hash_algorithm);
> +	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1 << desc->log_blocksize);

bitshifts should be done on unsigned types

	1U << desc->log_blocksize

> +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
> +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, desc->sig_size);
> +
> +	ret = send_cmd(sctx);
> +
> +tlv_put_failure:
> +out:
> +	return ret;
> +}
> +
> +static int process_new_verity(struct send_ctx *sctx)
> +{
> +	int ret = 0;
> +	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
> +	struct inode *inode;
> +	struct fsverity_descriptor *desc;
> +	struct fs_path *p;
> +
> +	inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);
> +	if (ret < 0)
> +		goto iput;
> +
> +	if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
> +		ret = -EMSGSIZE;
> +		goto iput;
> +	}
> +	desc = kmalloc(ret, GFP_KERNEL);

I think that once there's a file with verity record there will be more
so it would make sense to cache the allocated memory, which means to
allocate the full size.

FS_VERITY_MAX_DESCRIPTOR_SIZE is 16K so this should be allocated by
kvmalloc, like we have for other data during send.

> +	if (!desc) {
> +		ret = -ENOMEM;
> +		goto iput;
> +	}
> +
> +	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, desc, ret);
> +	if (ret < 0)
> +		goto free_desc;
> +
> +	p = fs_path_alloc();
> +	if (!p) {
> +		ret = -ENOMEM;
> +		goto free_desc;
> +	}
> +	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> +	if (ret < 0)
> +		goto free_path;
> +
> +	ret = send_verity(sctx, p, desc);
> +	if (ret < 0)
> +		goto free_path;
> +
> +free_path:
> +	fs_path_free(p);
> +free_desc:
> +	kfree(desc);
> +iput:
> +	iput(inode);
> +	return ret;
> +}
> +
>  static inline u64 max_send_read_size(const struct send_ctx *sctx)
>  {
>  	return sctx->send_max_size - SZ_16K;
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -92,8 +92,11 @@ enum btrfs_send_cmd {
>  	BTRFS_SEND_C_ENCODED_WRITE	= 25,
>  	BTRFS_SEND_C_MAX_V2		= 25,
>  
> +	/* Version 3 */
> +	BTRFS_SEND_C_ENABLE_VERITY	= 26,

I find the name confusing, it sounds like enabling it for the whole
filesystem, but it affects only one file.

> +	BTRFS_SEND_C_MAX_V3		= 26,
>  	/* End */
> -	BTRFS_SEND_C_MAX		= 25,
> +	BTRFS_SEND_C_MAX		= 26,
>  };
>  
>  /* attributes in send stream */
> @@ -160,8 +163,14 @@ enum {
>  	BTRFS_SEND_A_ENCRYPTION		= 31,
>  	BTRFS_SEND_A_MAX_V2		= 31,
>  
> -	/* End */
> -	BTRFS_SEND_A_MAX		= 31,
> +	/* Version 3 */
> +	BTRFS_SEND_A_VERITY_ALGORITHM	= 32,
> +	BTRFS_SEND_A_VERITY_BLOCK_SIZE	= 33,
> +	BTRFS_SEND_A_VERITY_SALT_DATA	= 34,
> +	BTRFS_SEND_A_VERITY_SIG_DATA	= 35,
> +	BTRFS_SEND_A_MAX_V3		= 35,
> +
> +	__BTRFS_SEND_A_MAX		= 35,
>  };
