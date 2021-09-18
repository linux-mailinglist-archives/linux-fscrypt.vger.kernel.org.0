Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2932841087F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Sep 2021 22:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhIRUF5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Sep 2021 16:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhIRUF5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Sep 2021 16:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DDF560EE0;
        Sat, 18 Sep 2021 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631995473;
        bh=51V67GGlO2aQjNO7+m1F023ROeDZk5YVuiZzm9xqIQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HR0KBJcstmuQQGd91VlAHmeOj3Qsy0hSSjFPYHb+aOsd4Xwm2tUwrwk3WVAWUqnSC
         6x5ep8gJ4Esh09Qbb6zaHFBUhjqm8z3gvH4tTagVG8R+GZknPZMucDiisWmab+9fnf
         S3UPuWmT1jO63SQ8I4von2sdaJ2gxggoNC6o/22ct1OM+M3R2qaCP1lPaw8GZpYRCK
         EQvXHR8YKWQ06KjocYz07R9mxmSO2+gsoCqJPHzYAzSKiKvjq6ENHChHKywWEApuTz
         kXg8WFDx0ENHX7M3buu8aO+05KUAU+bTmYTpU31njaWywkD00oTVyVNuBp2Emxpswi
         SdDoLzRpLQ0qA==
Date:   Sat, 18 Sep 2021 13:04:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>,
        Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils] 1.4: test suite does not build
Message-ID: <YUZGUIRpVjNpupSi@sol.localdomain>
References: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Sep 18, 2021 at 02:20:45PM +0100, Tomasz Kłoczko wrote:
> Hi,
> 
> Looks like it some issue with test suite because it does not link correctly
> 
> + cd fsverity-utils-1.4

It looks like you're actually building from the master branch, not 1.4?
1.4 doesn't have the code that is causing warnings below.

> lib/sign_digest.c: In function 'load_pkcs11_private_key':
> lib/sign_digest.c:351:9: warning: 'ENGINE_by_id' is deprecated: Since
> OpenSSL 3.0 [-Wdeprecated-declarations]
>   351 |         engine = ENGINE_by_id("dynamic");
>       |         ^~~~~~
> In file included from lib/sign_digest.c:23:
> /usr/include/openssl/engine.h:336:31: note: declared here
>   336 | OSSL_DEPRECATEDIN_3_0 ENGINE *ENGINE_by_id(const char *id);
>       |                               ^~~~~~~~~~~~
> lib/sign_digest.c:356:9: warning: 'ENGINE_ctrl_cmd_string' is
> deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
>   356 |         if (!ENGINE_ctrl_cmd_string(engine, "SO_PATH",
>       |         ^~
> In file included from lib/sign_digest.c:23:
> /usr/include/openssl/engine.h:479:5: note: declared here
>   479 | int ENGINE_ctrl_cmd_string(ENGINE *e, const char *cmd_name,
> const char *arg,
>       |     ^~~~~~~~~~~~~~~~~~~~~~
> lib/sign_digest.c:358:13: warning: 'ENGINE_ctrl_cmd_string' is
> deprecated: Since OpenSSL 3.0 [-Wdeprecated-declarations]
>   358 |             !ENGINE_ctrl_cmd_string(engine, "ID", "pkcs11", 0) ||

Aleksander, can you look into these?

- Eric
