Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84BD4739AD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 01:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhLNAkb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 19:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhLNAk3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 19:40:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A14DC061574;
        Mon, 13 Dec 2021 16:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D98B8049B;
        Tue, 14 Dec 2021 00:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DCFC34603;
        Tue, 14 Dec 2021 00:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639442426;
        bh=Yih2AcbxV+p2TGTssEFKTcxp5q4SEGLhyzF9UCNqeJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ps7asxhnjBL4tTp64xzrDYvzC+11gIoxjqVbdR6vrOu2EwiUEH/GN1IYGoz/DiJ+t
         j9dP3yq8HTj10Fvhtqsu8CXVKRipKFpbJPT4khr8UacAyrMTgPy31mpjnfJFEzr4Uf
         1C5zZpjymmJ4NJiE+pu+3Y7LWLgCA/Maz9D1vmh6Lrd4XydxYFZrSvDWnvQdzZfkmK
         C87txHWo+UZ4D0Cyy4+PO8ogr3DU7z34LwXa/zMfJ59bkLBP1F7WS7FiWVzNOnOqRt
         EBQhYAST7ox3FjCS9fEUDgg9kuopIugD3/IDv5fYmlMqzCXFv74zexPNVfSqAc2Eza
         MHjurVCKGuH6Q==
Date:   Mon, 13 Dec 2021 16:40:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 02/10] scsi: ufs: qcom: move ICE functionality to common
 library
Message-ID: <Ybfn+LjJ7PdfIHS0@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-3-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-3-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:17PM -0800, Gaurav Kashyap wrote:
> Remove the ICE support in UFS and use the shared library
> for crypto functionality.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Can you reword this to make it clear that this patch isn't removing ICE support
from the UFS driver, but rather just refactoring how it is implemented?

Also please make sure to clearly describe any changes in behavior, or else
reorder the patchset so that no behavior is changed until after the conversion.
There are some behavior changes that I pointed out on the previous patch.

- Eric
