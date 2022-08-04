Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63656589D83
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Aug 2022 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiHDOcv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Aug 2022 10:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239644AbiHDOcu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Aug 2022 10:32:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A82249B43;
        Thu,  4 Aug 2022 07:32:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DD7B95BD38;
        Thu,  4 Aug 2022 14:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659623567;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMtjGgCqsYZMUmNPEvLS1Jt9XLInd23RpmaUPcNJ5JI=;
        b=ZkKPCFDbNmfvz0n/sdRIP6yFwTkFPV7U+G2kGypzQHjgwO/Z8QjttTx55agzbOFBEiOZH3
        KUYNGuvMUM3vOHTs2Z7HdW/HqZuP7RhpGLVW6uadqp8PaQxsxdIKOLilD6ClOaUAGfspHI
        2P3utCe33A1L59F83Yxf6YeX3UPqThk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659623567;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMtjGgCqsYZMUmNPEvLS1Jt9XLInd23RpmaUPcNJ5JI=;
        b=dXF1yCfIGYaVq+cQBFYA64l1tC9orRkEDzsZe0r9Dlxc/xQBxwgMisCT9swaKqsgyCTrOg
        rWCL7r4UrbRoxcCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B99D513A94;
        Thu,  4 Aug 2022 14:32:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BitcLI/Y62JmeAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 04 Aug 2022 14:32:47 +0000
Date:   Thu, 4 Aug 2022 16:27:44 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3] btrfs: send: add support for fs-verity
Message-ID: <20220804142744.GP13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 01, 2022 at 11:54:40AM -0700, Boris Burkov wrote:
> +static int process_new_verity(struct send_ctx *sctx)
> +{
> +	int ret = 0;
> +	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
> +	struct inode *inode;
> +	struct fs_path *p;
> +
> +	inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);

This is a long way to call btrfs_get_verity_descriptor from
fs/btrfs/verity.c , is there a reason we can't call it directly?

> +	if (ret < 0)
> +		goto iput;
> +
> +	if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
> +		ret = -EMSGSIZE;
> +		goto iput;
> +	}
> +	if (!sctx->verity_descriptor) {
> +		sctx->verity_descriptor = kvmalloc(FS_VERITY_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
> +		if (!sctx->verity_descriptor) {
> +			ret = -ENOMEM;
> +			goto iput;
> +		}
> +	}
> +
> +	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, sctx->verity_descriptor, ret);
> +	if (ret < 0)
> +		goto iput;
> +
> +	p = fs_path_alloc();
> +	if (!p) {
> +		ret = -ENOMEM;
> +		goto iput;
> +	}
> +	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> +	if (ret < 0)
> +		goto free_path;
> +
> +	ret = send_verity(sctx, p, sctx->verity_descriptor);
> +	if (ret < 0)
> +		goto free_path;
> +
> +free_path:
> +	fs_path_free(p);
> +iput:
> +	iput(inode);
> +	return ret;
> +}
