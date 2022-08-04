Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B87589D7B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Aug 2022 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiHDOaT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Aug 2022 10:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiHDOaR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Aug 2022 10:30:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34572DAB;
        Thu,  4 Aug 2022 07:30:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CD79E3411D;
        Thu,  4 Aug 2022 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659623414;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0GxlzLl5N/q4v62y+5BJb9ld2PxnwSUsfvZNFvra8Uw=;
        b=oCsZpV76HzNHC+iamz1PSkriEMMZbqzf/Y+GeH4arjQeql/kCPquA5+OXariZMXuYJqC2Z
        rc7UvnEoMWs+9ywDiU16Rmb/YnRbTNEojmTG7N9exB6ma5zRMxXjHNFafhUXwAXIHkmluZ
        c1y/y5CFk183Z12ANmzszrWHEZ4mZlE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659623414;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0GxlzLl5N/q4v62y+5BJb9ld2PxnwSUsfvZNFvra8Uw=;
        b=uAhpHODDA2REa0EdoB7D8sSUU0zphBylmaR0hmZftxw3FtJscF+bNj9YhyoNcenLHJ6kV2
        GK3eCzHhTKKHJ7BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9575313A94;
        Thu,  4 Aug 2022 14:30:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qoyaI/bX62JzdwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 04 Aug 2022 14:30:14 +0000
Date:   Thu, 4 Aug 2022 16:25:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3] btrfs: send: add support for fs-verity
Message-ID: <20220804142511.GO13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
 <YumLTcHPUL5M8rY8@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YumLTcHPUL5M8rY8@sol.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 02, 2022 at 01:38:37PM -0700, Eric Biggers wrote:
> On Mon, Aug 01, 2022 at 11:54:40AM -0700, Boris Burkov wrote:
> > +#ifdef CONFIG_FS_VERITY
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
> > +	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1U << desc->log_blocksize);
> > +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
> > +	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, (int)desc->sig_size);
> 
> le32_to_cpu(desc->sig_size)

Don't all the members of desc need the le/cpu helpers? The whole
structure is read from disk directly to the memory buffer, there's no
conversion to a cpu-native order structure, so this must be done when
the members are accessed.

While the first four are of type __u8 so there's no endianness
conversion needed, I'd rather do it for clarity that the structure needs
special handling.

> > +	ret = send_cmd(sctx);
> > +
> > +tlv_put_failure:
> > +out:
> > +	return ret;
> > +}
> 
> The 'out' label is unnecessary.

It's a common pattern in send callbacks to have out: label next to
tlv_put_failure.

> > +static int process_new_verity(struct send_ctx *sctx)
> 
> What does "new verity" mean in this context?  The other functions called by
> finish_inode_if_needed() have names like send_chown(), send_chmod(), etc., so
> this name seems inconsistent (although I'm not familiar with this code).

Yeah I think process_verity or process_verity_desc will be better.

> > +	ret = send_verity(sctx, p, sctx->verity_descriptor);
> > +	if (ret < 0)
> > +		goto free_path;
> > +
> > +free_path:
> > +	fs_path_free(p);
> 
> The goto above is unnecessary.
> 
> > +static int process_new_verity(struct send_ctx *sctx)
> > +{
> > +	int ret = 0;
> > +	struct send_ctx tmp;
> > +
> > +	return -EPERM;
> > +	/* avoid unused TLV_PUT_U8 build warning without CONFIG_FS_VERITY */
> > +	TLV_PUT_U8(&tmp, 0, 0);
> > +tlv_put_failure:
> > +	return -EPERM;
> > +}
> > +#endif
> 
> How about adding __maybe_unused to tlv_put_u##bits instead?

Or it could use U16 or U32 type, it's not strictly necessary to use the
same type width as the in-memory structures.
