Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1078D60CBF0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 14:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiJYMfc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Oct 2022 08:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiJYMfV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Oct 2022 08:35:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00611440AF;
        Tue, 25 Oct 2022 05:35:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7D51D22052;
        Tue, 25 Oct 2022 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666701317;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OpgKvV3U18R8eSqeubndIO8GWS0L6TAXctfORtP3CxI=;
        b=V/ViMDgVSglQ6SU+K9thwThVT8zsLrqfx4VxaGK+IzARyZqJf3fdIyzO+ggzgk9g1RmNsL
        wqzhBaj5+ScmTIlODWM1eMsXV/gXUrVpzdJM4XmSbGotBGXg4o4PpaEEFuzWitCIikHYwn
        E+cG/ZBZ81VnQkBTcamxEy7G/2PsAjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666701317;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OpgKvV3U18R8eSqeubndIO8GWS0L6TAXctfORtP3CxI=;
        b=VfdZngUUElTfHf7hUYAntFbEg6aQLSmIUjqSTtNTXVWBJb3QAkN2WNapnjBS4FjNBvzD42
        MrD30DHHWIMPEfBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2FAE813A64;
        Tue, 25 Oct 2022 12:35:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4biHCgXYV2PPHgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 25 Oct 2022 12:35:17 +0000
Date:   Tue, 25 Oct 2022 14:35:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 00/21] btrfs: add fscrypt integration
Message-ID: <20221025123503.GJ5824@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1666651724.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 24, 2022 at 07:13:10PM -0400, Sweet Tea Dorminy wrote:
> Omar Sandoval (11):
>   btrfs: store directory encryption state

> Sweet Tea Dorminy (10):
>   btrfs: use struct qstr instead of name and namelen
>   btrfs: setup qstrings from dentrys using fscrypt helper
>   btrfs: use struct fscrypt_str instead of struct qstr

FYI, the patches listed above have been addded to misc-next as they're
preparatory (no fscrypt related code there except using fscrypt_name).
There are some fixups so you may encounter minor conflicts when
rebasing.
