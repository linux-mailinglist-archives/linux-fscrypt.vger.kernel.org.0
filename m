Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE15952F16F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 May 2022 19:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348238AbiETRV0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 May 2022 13:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbiETRVZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 May 2022 13:21:25 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A4A39164;
        Fri, 20 May 2022 10:21:24 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id BFD491F46726
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653067283;
        bh=nxHUg1U1wjVU0hfczLwATkd9dA/b0ruMNZpmXbtKT4A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=j/9SsfLfim+cTj5jMfVxQ34lLVnFspAX/TnPixbH6JdcuuaI3E3YzOlkC4N8qwGcU
         slCCuUhMftUXUZ5q6sCNZvoa1cWMibArHRErbqGPDqsQyFTq37C1NvfQjqX8e6Az9t
         tlsvP+jtkbu6LYWBxC3xSmiLpSMg7ufA3+5RlG/7bW4UEmNQmaZxyB3eueYsglWsth
         m7cC4XO8HBeJztqpxmYGg9KufkvMK4uuVE1ye2St0JCEPOEUDCoPD09Kf+8h5Fz0pj
         ty7i9jpXJZUFKoz636w2kBgJuO0yIkYkeM2Ryve5ySUHR2RJdpAYlnazoVPdUYwDta
         eNR+O/DmLq+Ew==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, Daniel Rosenberg <drosen@google.com>
Subject: Re: [xfstests PATCH] generic/556: add test case for top-level dir
 rename
Organization: Collabora
References: <20220514180146.44775-1-ebiggers@kernel.org>
Date:   Fri, 20 May 2022 13:21:19 -0400
In-Reply-To: <20220514180146.44775-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Sat, 14 May 2022 11:01:46 -0700")
Message-ID: <87sfp46rxs.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> From: Eric Biggers <ebiggers@google.com>
>
> Test renaming a casefolded directory located in the top-level directory,
> while the cache is cold.  When $MOUNT_OPTIONS contains
> test_dummy_encryption, this detects an f2fs bug.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  tests/generic/556 | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>

-- 
Gabriel Krisman Bertazi
