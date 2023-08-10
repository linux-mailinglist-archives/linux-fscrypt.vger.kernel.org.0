Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F203E7770E2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 09:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjHJHD3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 03:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjHJHD1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 03:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496DBE2;
        Thu, 10 Aug 2023 00:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6B5650BA;
        Thu, 10 Aug 2023 07:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37ECC433C8;
        Thu, 10 Aug 2023 07:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691651005;
        bh=pZxb/6VLfcuUvO/OXvqqCBsbjJHdwOL21q/dkiRgUIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cTYSDMSgHU1dNyJDVQBxf6eHq1LoYQd/Am08fhTUFRgC21qD9l4yhfcWP98d2TqHc
         guFody0lZhkOWn90TdQdfSeskf2kHIRP+fUCS9JUATYeomop6Q2E70jg4XIkbWB15f
         6C1zVXMlTo+sDtNa3dJ3CgUUd0yRge0DQQdV7FL4llbt7+rR7fPDVHlX7biqnRc5h0
         pne3QUKePoC6tZUWdET10Zu614XiAh9ANtmWy8gbF+2Ut3k15TpWbgc68byTGwQFN4
         6RMyug8IW3WaXmfRM0VJa42Q8bYpVxRdMfBjPsyOiJr943dnlv8LXW7TenrYMYqj4c
         aMR/ZxS9zvCGg==
Date:   Thu, 10 Aug 2023 00:03:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 6/8] fscrypt: move all the shared mode key setup deeper
Message-ID: <20230810070323.GH923@sol.localdomain>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <953985195b4cce824ed64ee68827558544e93dcc.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <953985195b4cce824ed64ee68827558544e93dcc.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:06PM -0400, Sweet Tea Dorminy wrote:
> Currently, fscrypt_setup_v2_file_key() has a set of ifs which encode
> various information about how to set up a new mode key if necessary for
> a shared-key policy (DIRECT or IV_INO_LBLK_*). This is somewhat awkward
> -- this information is only needed at the point that we need to setup a
> new key, which is not the common case; the setup details are recorded as
> function parameters relatively far from where they're actually used; and
> at the point we use the parameters, we can derive the information
> equally well.
> 
> So this moves mode and policy checking as deep into the callstack as
> possible. mk_prepared_key_for_mode_policy() deals with the array lookup
> within a master key. And fill_hkdf_info_for mode_key() deals with
> filling in the hkdf info as necessary for a particular policy. These
> seem a little clearer in broad strokes, emphasizing the similarities
> between the policies, but it does spread out the information on how the
> key is derived for a particular policy more.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/keysetup.c | 131 +++++++++++++++++++++++++++++--------------
>  1 file changed, 88 insertions(+), 43 deletions(-)

Looking at this again, I think this patch makes things worse, not better.  The
diffstat is significantly positive, and it splits the handling of each policy
type into several more places, which makes it harder to understand how each one
works.  Also problematic is how the new code makes it look like HKDF context 0
is potentially used, which could confuse people trying to review the crypto.

Do any of your later patches depend on this patch?

- Eric
