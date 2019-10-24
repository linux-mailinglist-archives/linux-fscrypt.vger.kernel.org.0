Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19FEAE2DFB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Oct 2019 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393133AbfJXJzM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Oct 2019 05:55:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34155 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393132AbfJXJzL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Oct 2019 05:55:11 -0400
Received: by mail-lj1-f193.google.com with SMTP id j19so24321585lja.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 24 Oct 2019 02:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9wILYHfyzdPkt0/hYfDZOYs+W1i9jhuC4WjjgM1Si8Y=;
        b=IpXb8wbqDIysQMcczI3Yhg6ndMfUC/qO1n2oh1pfqBfcaSOjBY2M4hKGJOc1beCq5D
         1fEZ2xbxlTsQeDEZr1G04sZ4kUKj+ISehO2bczEcDmBRsRgQmnK6F7kioRcZC37cgrup
         vmRxaH1xcHO4QsObdDcLDt+tYY/X4NO0WmHkicCBgQTFWjaznJKfCbsJFLVWjKIGe9cK
         vkl0O8N5++mRgHGnPL9/E2qK+jjWF3KJaYmuOe4Au2F+sLZCEmRmqhc2IKIXfHDhS9Ha
         FitG0+ImgGaFwDTXsKfr5aGSPJetj+5gOSL7Iz1cYHO2WfngX3+RO1VjDcTzc1qP8bvl
         89uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9wILYHfyzdPkt0/hYfDZOYs+W1i9jhuC4WjjgM1Si8Y=;
        b=Hb3QhRdryzVNtTcjQfVSZ/3N03HRvyeTQBz1wjhChAkBcIYcE+G0KuxzUEA+xR3Zg6
         9Sm6+jEsZY4u9cMxhvdDQIKW0Eo6Uopqm+ZUZcVj+rrrK3Pc47ZAM+eHZIuoIw6QCdmv
         evEYS2O2X1H1A8hZ1YC8ndPJJEpp4cRHZ0ercZoJYtu5wRuNgPxpAiFtbOflTS3kP3vY
         9jDFCF64Nn06fJqe6QyKhz1tN3xaZZJ9rCiZJahxwPzO1rQyl9bHHy5ZzXNIsBd2GzOh
         FpCcpna3ExZLW/Rd0bt4TRdG1/pX09xFB0SLuW4OqYJcGkfr9rhlPv/S/FiaKoodyLaY
         0IZA==
X-Gm-Message-State: APjAAAWUvxkmyfxFdpFedp2MnEBxT8CqLMbQBOYHy3vB01MHC18Xyirv
        cMNYvaBNaxxx22+Oy0Tr/rOiEKttNoZmhICEBzDaTA==
X-Google-Smtp-Source: APXvYqxBv5EsXSTuCFpOoZBFR/UcS+e+e+GLT4cUj9tmnnXozis1KsX31ONH2VX0dK4f4qIMdJE6LN+XlFXFhBblhXs=
X-Received: by 2002:a05:651c:1b9:: with SMTP id c25mr24647960ljn.163.1571910908888;
 Thu, 24 Oct 2019 02:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20191021230355.23136-1-ebiggers@kernel.org> <20191021230355.23136-2-ebiggers@kernel.org>
 <20191022052712.GA2083@dread.disaster.area> <20191022060004.GA333751@sol.localdomain>
 <20191022133001.GA23268@mit.edu> <20191023092718.GA23274@infradead.org>
 <20191023125701.GA2460@mit.edu> <20191024012759.GA32358@infradead.org>
 <20191024024459.GA743@sol.localdomain> <20191024070433.GB16652@infradead.org>
In-Reply-To: <20191024070433.GB16652@infradead.org>
From:   Paul Crowley <paulcrowley@google.com>
Date:   Thu, 24 Oct 2019 02:54:57 -0700
Message-ID: <CA+_SqcAZPETtuEcSkcwiZcRV7QHr0jq0+oGgF=k+M5bEuxKhVQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] fscrypt: add support for inline-encryption-optimized policies
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Satya Tangirala <satyat@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 24 Oct 2019 at 00:04, Christoph Hellwig <hch@infradead.org> wrote:
> I think not making it crazy verbose is a helpful, but at the same time
> it should be somewhat descriptive.

What would your suggested name be?
