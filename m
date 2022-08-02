Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2759A58832B
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Aug 2022 22:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiHBUlt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Aug 2022 16:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiHBUls (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Aug 2022 16:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51D32FFE6;
        Tue,  2 Aug 2022 13:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDC060B70;
        Tue,  2 Aug 2022 20:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FBFC433C1;
        Tue,  2 Aug 2022 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659472905;
        bh=0l2K0CE8QJGS0iXPuakUsFEqB72QGZ4Z2VYml0BZsvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=li6QEsKRRvggALntxwfM4iyJXnWYGTPWh7LyNqAROWSQWsIdc8Y/1fWQdh1OM+Cet
         dHrlqqvqJ1VshSXONMHTd3rX/t0RIeXvSckNHPojGcXTukHFf7yAQE7QVMgzWO6azI
         0jrUnbHyq3v85KPMuhiSTaE4+0N5NsjAojsu/VvdCBzDCcr12MeOnBrmFURoteSEZs
         AFHz+7dOUfP7yrFmYhNQ8EiSxdCLa5tROugF9+GMoZQ8VF8atLOdCyXK7szSBW9KUG
         Yv2oIW/wodUC6wSx0zFBA3TjmXzNtZPcNTNQVjC/RuOfVuZDdSdzzPEtkfKbf5gb1U
         tWFRfIFPLaFpg==
Date:   Tue, 2 Aug 2022 13:41:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs-progs: receive: add support for fs-verity
Message-ID: <YumMCGlxNWCV/k9G@sol.localdomain>
References: <e4789647b76c8b45c95256deed1cba583993b8b1.1659031931.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4789647b76c8b45c95256deed1cba583993b8b1.1659031931.git.boris@bur.io>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 28, 2022 at 11:14:35AM -0700, Boris Burkov wrote:
> +static int process_enable_verity(const char *path, u8 algorithm, u32 block_size,
> +				 int salt_len, char *salt,
> +				 int sig_len, char *sig, void *user)
> +{
> +	int ret;
> +	struct btrfs_receive *rctx = user;
> +	char full_path[PATH_MAX];
> +	struct fsverity_enable_arg verity_args = {
> +		.version = 1,
> +		.hash_algorithm = algorithm,
> +		.block_size = block_size,
> +	};
> +	if (salt_len) {
> +		verity_args.salt_size = salt_len;
> +		verity_args.salt_ptr = (__u64)salt;
> +	}
> +	if (sig_len) {
> +		verity_args.sig_size = sig_len;
> +		verity_args.sig_ptr = (__u64)sig;
> +	}

Casting a pointer to a __u64 needs to be done using (__u64)(uintptr_t),
otherwise it will cause a warning on 32-bit platforms.

> +	/*
> +	 * Enabling verity denies write access, so it cannot be done with an
> +	 * open writeable file descriptor.
> +	 */
> +	close_inode_for_write(rctx);
> +	ret = ioctl(ioctl_fd, FS_IOC_ENABLE_VERITY, &verity_args);
> +	if (ret < 0)
> +		fprintf(stderr, "Failed to enable verity on %s: %d\n", full_path, ret);

Errors from ioctl() are returned in errno, not in the return value.

- Eric
