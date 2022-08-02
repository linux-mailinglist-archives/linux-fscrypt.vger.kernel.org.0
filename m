Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CA2588329
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Aug 2022 22:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiHBUim (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Aug 2022 16:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiHBUik (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Aug 2022 16:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CCC32D95;
        Tue,  2 Aug 2022 13:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EBD614F7;
        Tue,  2 Aug 2022 20:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50CEC433D6;
        Tue,  2 Aug 2022 20:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659472719;
        bh=gAlMSC4Zg7NNs3OMljffAiasO4r7diFQkVfRrKOg/OE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9ZKW1uABMjUnWHO40yCG7TFU8T6d6mDNYCLZBwlq9SJgXc95MaanvW8JI7VjWntp
         qlFPRWKJCDtfOFfTIF+R6bkY8Lzj2gsilhZI/ZQCHt82VZeHt1mY9Yj+/l1HQnLX5n
         lsb4YeM7MkvH2Gw17txd2mPt9/FcqAntQwIuQxLsdgkUDUM5aH17C0nyuBAGjz2sa4
         /Lky89a1Zr5m+/G9B5TC+uwyCU19H00eGohSuNsVbb8GRriIgsFMHEikAwVV0Wu+Y+
         T35+2qMS6/w9xnz9Lfy7hbBCPQ2b+bXu0c3QMZFDwPP8+xuva1xd0nUJnch/8bJasj
         NxN3qh+ywG35g==
Date:   Tue, 2 Aug 2022 13:38:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3] btrfs: send: add support for fs-verity
Message-ID: <YumLTcHPUL5M8rY8@sol.localdomain>
References: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 01, 2022 at 11:54:40AM -0700, Boris Burkov wrote:
> +#ifdef CONFIG_FS_VERITY
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
> +	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1U << desc->log_blocksize);
> +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
> +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, (int)desc->sig_size);

le32_to_cpu(desc->sig_size)

> +
> +	ret = send_cmd(sctx);
> +
> +tlv_put_failure:
> +out:
> +	return ret;
> +}

The 'out' label is unnecessary.

> +
> +static int process_new_verity(struct send_ctx *sctx)

What does "new verity" mean in this context?  The other functions called by
finish_inode_if_needed() have names like send_chown(), send_chmod(), etc., so
this name seems inconsistent (although I'm not familiar with this code).

> +
> +	ret = send_verity(sctx, p, sctx->verity_descriptor);
> +	if (ret < 0)
> +		goto free_path;
> +
> +free_path:
> +	fs_path_free(p);

The goto above is unnecessary.

> +static int process_new_verity(struct send_ctx *sctx)
> +{
> +	int ret = 0;
> +	struct send_ctx tmp;
> +
> +	return -EPERM;
> +	/* avoid unused TLV_PUT_U8 build warning without CONFIG_FS_VERITY */
> +	TLV_PUT_U8(&tmp, 0, 0);
> +tlv_put_failure:
> +	return -EPERM;
> +}
> +#endif

How about adding __maybe_unused to tlv_put_u##bits instead?

> @@ -8036,6 +8148,8 @@ long btrfs_ioctl_send(struct inode *inode, struct btrfs_ioctl_send_args *arg)
>  		kvfree(sctx->clone_roots);
>  		kfree(sctx->send_buf_pages);
>  		kvfree(sctx->send_buf);
> +		if (sctx->verity_descriptor)
> +			kvfree(sctx->verity_descriptor);

There's no need to check for NULL before calling kvfree().

- Eric
