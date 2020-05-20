Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8BC1DA821
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 04:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgETCmp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 May 2020 22:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgETCmo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 May 2020 22:42:44 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFFE2075F;
        Wed, 20 May 2020 02:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589942564;
        bh=bmo77SWZ149DSWXeF7xD4RXlCovls58Uq43BGC+EmhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdcUpheYqxhtWMDDuNZU6tMpYtb959Tc4k95jXHgN0i/YZ69TskdPneF7sRf6t3hY
         Gz175RElScPyBMrsnANBeE0Y3N8s9CSjpHJvFAivzxlGL7paPpwFRTyeZIdcnIJDYy
         mw91Kts0vAInSIUMPj9UsdcvxjmkMiR7vk+Y0vm0=
Date:   Tue, 19 May 2020 19:42:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 1/2] Fix Makefile to delete objects from the library on
 make clean
Message-ID: <20200520024243.GA3510@sol.localdomain>
References: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
 <20200515205649.1670512-2-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515205649.1670512-2-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 15, 2020 at 04:56:48PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index 1a7be53..c5f46f4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -81,6 +81,7 @@ LIB_SRC         := $(wildcard lib/*.c)
>  LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
>  STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
>  SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
> +LIB_OBJS        := $(SHARED_LIB_OBJ) $(STATIC_LIB_OBJ)
>  
>  # Compile static library object files
>  $(STATIC_LIB_OBJ): %.o: %.c $(LIB_HEADERS) .build-config
> -- 

Thanks for pointing this out.  I think it would be a bit easier to just use a
wildcard in the clean target, though.

diff --git a/Makefile b/Makefile
index 1a7be53..e7fb5cf 100644
--- a/Makefile
+++ b/Makefile
@@ -180,8 +180,8 @@ help:
 	done
 
 clean:
-	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) $(LIB_OBJS) $(ALL_PROG_OBJ) \
-		.build-config
+	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
+		lib/*.o programs/*.o .build-config
 
 FORCE:
 
