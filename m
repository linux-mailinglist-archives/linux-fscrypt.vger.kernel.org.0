Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B7870D074
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 May 2023 03:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjEWBXR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 22 May 2023 21:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbjEWBXQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 22 May 2023 21:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8817B7;
        Mon, 22 May 2023 18:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D872C61990;
        Tue, 23 May 2023 01:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C954C433D2;
        Tue, 23 May 2023 01:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684804989;
        bh=vjk5rZMZaeZfGz8DvSil6k+A6PfapIMUVus7AmNsfMU=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=FSvm9ect3zqer7zjI3xf1P8L/M6O4vv49bjcpdYLXBJ46m6SmJeLkujNgmgla6Gmr
         36iyyOEYcsoeeKOZIts+NiGmPIg4VGcZYt/URe2+cIyJuzgq50iaKrFk5hbrcFyuzj
         DFwO6buNlp3cYxGr1L3GjPFJuT+uBnauX/X++RHH1rixz1z+PGQN1sXM4bI15ANPT3
         rsOBLWQOOcz0OfxHENqLtAu/FzuPyYaWO7ON6uZB8aEIZq9bz//xmjBFn9+YK4zIjI
         A3gorKcrIttkE5d9r1M5Pv+jx1Sp/auQ2wXCHlE5cj/T9RV2DUfkyzvDwNzjfCXWvq
         Crdt6aOYxm7aQ==
Date:   Mon, 22 May 2023 18:23:06 -0700
From:   Kees Cook <kees@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
CC:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Replace 1-element array with flexible array
User-Agent: K-9 Mail for Android
In-Reply-To: <20230522230206.GA3187780@google.com>
References: <20230522213924.never.119-kees@kernel.org> <20230522230206.GA3187780@google.com>
Message-ID: <F340AF2B-C611-48FE-BCB6-C4FF45005409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On May 22, 2023 4:02:06 PM PDT, Eric Biggers <ebiggers@kernel=2Eorg> wrote:
>On Mon, May 22, 2023 at 02:39:28PM -0700, Kees Cook wrote:
>> In the future, we can add annotations for the flexible array member
>> "encrypted_path" to have a size determined by the "len" member=2E
>
>That seems unlikely, as 'struct fscrypt_symlink_data' is an on-disk data
>structure=2E  The "len" field does not necessarily use CPU endianness, an=
d before
>being validated it might be greater than the size of the allocated space=
=2E

Oh yes, good point=2E

>I agree that it should use a flex array (and thanks for catching this one=
 that I
>had forgotten about=2E=2E=2E), but the above explanation seems wrong=2E

Shall I spin a v2?


--=20
Kees Cook
