Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF905B350F
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Sep 2022 12:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiIIKUu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Sep 2022 06:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiIIKUs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Sep 2022 06:20:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E8D9753A;
        Fri,  9 Sep 2022 03:20:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8AEF11F8E4;
        Fri,  9 Sep 2022 10:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662718845;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J9Rfv2Xu2oJsNn9jUH3+EAKEPH7FUVJq2VDHNQJ6i9k=;
        b=29E/1PC3fCVxOylK7tGMh5uNooWbNYquYcRZCfWu/dFg/xbU9dQ7nOQuQxda3PZ3SdFkLO
        BQB1n23ZHxSpzSPjtiY2F9hTHi41zXnLCCIKwEh8fMiLDW1kyKHpQKeWt6LyPeedsg/cUZ
        F0nO6CHdaKXnFNmtWjsWl+eJrgyc+w0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662718845;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J9Rfv2Xu2oJsNn9jUH3+EAKEPH7FUVJq2VDHNQJ6i9k=;
        b=ZxVITUXbyng7DS9k5D2Ea4EILK7b0cwtpBRig4zLn2LTagAHw7u77ReJd5tVdEnaRC1OXd
        fTjvk0PHEl6gIdDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52D8013A93;
        Fri,  9 Sep 2022 10:20:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4NdhE30TG2PvdQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 09 Sep 2022 10:20:45 +0000
Date:   Fri, 9 Sep 2022 12:15:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Message-ID: <20220909101521.GS32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:25PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020 Facebook
> + */

Please use only SPDX in new files

https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
