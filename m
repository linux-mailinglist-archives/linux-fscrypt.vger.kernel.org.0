Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5F587E77
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Aug 2022 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbiHBO5K (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Aug 2022 10:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbiHBO5I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Aug 2022 10:57:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F9B1F2FB;
        Tue,  2 Aug 2022 07:57:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E2A861FFAC;
        Tue,  2 Aug 2022 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659452225;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FKwWygOq+y9KKvLKtalePQ4lNnZoMGvEr5bPV+5rmaQ=;
        b=s6M1szGiXLtpNY+e5DJQfDk6LbkSNURTu71AOIwKDazUmPwqonzM7GFCEA2hWeyWdVVSyM
        LjQ4trI0wCgytI/2exZM3wAVmY3NxVgtc+gdqUc3Z9FUxAH9L4m3f7umzv/Q9JYUCFXdFg
        uyXgA+FDpogjcMg3bjyFd1N5FaTgzt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659452225;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FKwWygOq+y9KKvLKtalePQ4lNnZoMGvEr5bPV+5rmaQ=;
        b=+VJ+Uib40mopV9WA5RboAI8zVIX9aUiT9Qu0qGx+DMi2gLbp+XCRo+wuGHTsnvDecxZVQY
        Z1uz4UBWiFWnyECg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B989313A8E;
        Tue,  2 Aug 2022 14:57:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UFNmLEE76WLRAwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 02 Aug 2022 14:57:05 +0000
Date:   Tue, 2 Aug 2022 16:52:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs-progs: receive: add support for fs-verity
Message-ID: <20220802145204.GO13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <e4789647b76c8b45c95256deed1cba583993b8b1.1659031931.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4789647b76c8b45c95256deed1cba583993b8b1.1659031931.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 28, 2022 at 11:14:35AM -0700, Boris Burkov wrote:
> Process an enable_verity cmd by running the enable verity ioctl on the
> file. Since enabling verity denies write access to the file, it is
> important that we don't have any open write file descriptors.
> 
> This also revs the send stream format to version 3 with no format
> changes besides the new commands and attributes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> --
> Changes for v2:
> - remove verity.h copy, use UAPI
> ---
>  cmds/receive-dump.c  | 10 +++++++++
>  cmds/receive.c       | 51 ++++++++++++++++++++++++++++++++++++++++++++
>  common/send-stream.c | 16 ++++++++++++++
>  common/send-stream.h |  3 +++
>  kernel-shared/send.h | 13 +++++++++--
>  5 files changed, 91 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds/receive-dump.c b/cmds/receive-dump.c
> index 92e0a4c9a..5d68ecbca 100644
> --- a/cmds/receive-dump.c
> +++ b/cmds/receive-dump.c
> @@ -344,6 +344,15 @@ static int print_fileattr(const char *path, u64 attr, void *user)
>  	return PRINT_DUMP(user, path, "fileattr", "fileattr=0x%llu", attr);
>  }
>  
> +static int print_enable_verity (const char *path, u8 algorithm, u32 block_size,
> +				int salt_len, char *salt,
> +				int sig_len, char *sig, void *user)
> +{
> +	return PRINT_DUMP(user, path, "enable_verity",
> +			  "algorithm=%u block_size=%u salt_len=%d sig_len=%d",
> +			  algorithm, block_size, salt_len, sig_len);
> +}
> +
>  struct btrfs_send_ops btrfs_print_send_ops = {
>  	.subvol = print_subvol,
>  	.snapshot = print_snapshot,
> @@ -369,4 +378,5 @@ struct btrfs_send_ops btrfs_print_send_ops = {
>  	.encoded_write = print_encoded_write,
>  	.fallocate = print_fallocate,
>  	.fileattr = print_fileattr,
> +	.enable_verity = print_enable_verity,
>  };
> diff --git a/cmds/receive.c b/cmds/receive.c
> index aec324587..c4778d6c0 100644
> --- a/cmds/receive.c
> +++ b/cmds/receive.c
> @@ -39,6 +39,7 @@
>  #include <sys/uio.h>
>  #include <sys/xattr.h>
>  #include <linux/fs.h>
> +#include <linux/fsverity.h>

This fails on Centos 7 that is used as base for build support. As
mentioned before, we can either ship local header to make it compile or
ifdef it out and skip verity records on receive side.  We already have
conditional compresion support for receive, but mostly it's by user
choice not because of lack of support.

You can test if it builds with docker and ci/ci-build-centos7 .
