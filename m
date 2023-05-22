Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D70B70CE5F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 May 2023 01:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjEVXCL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 22 May 2023 19:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjEVXCJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 22 May 2023 19:02:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05BBE0;
        Mon, 22 May 2023 16:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67DCE62C8D;
        Mon, 22 May 2023 23:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BD7C433D2;
        Mon, 22 May 2023 23:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684796527;
        bh=u8N+OPaghwg762KuxUjVvzRa7zi3LaGglh2Va+BvGUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o56/0pLv5cr+nA88DjGzAvPh11y4D3P6vBdgS3uHc7g9x9OwUty5xnEVTLyUODRap
         H3dpY4ea4VS/pfANpVXycVaBrKMeHKutUJardXt9O0qBHPcGkhC3hqDH1OQgGHGYJS
         kfjquvQE7kAoiDIrpdNDOQ+xhNzJo6yiIRAVqkuE6y3SfTS6X8LG4TRWYic1Yx5PWQ
         M6VwTL8EVmhJ1kiU2dI5Uv0vLLtD7KmtFgpgK6CyfXpu9AlOt/NVs07qFebkVCGWL8
         04qpnyGMTfja8wKQ5LkxJeV2u0sq/ieRcELOkKntTVj+uFDiscUt7f1p21PaeKTVme
         4UWINAV8E6mgw==
Date:   Mon, 22 May 2023 23:02:06 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Replace 1-element array with flexible array
Message-ID: <20230522230206.GA3187780@google.com>
References: <20230522213924.never.119-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522213924.never.119-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 22, 2023 at 02:39:28PM -0700, Kees Cook wrote:
> In the future, we can add annotations for the flexible array member
> "encrypted_path" to have a size determined by the "len" member.

That seems unlikely, as 'struct fscrypt_symlink_data' is an on-disk data
structure.  The "len" field does not necessarily use CPU endianness, and before
being validated it might be greater than the size of the allocated space.

I agree that it should use a flex array (and thanks for catching this one that I
had forgotten about...), but the above explanation seems wrong.

- Eric
